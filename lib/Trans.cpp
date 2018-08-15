//===- Based on InstCounter.cpp - Example code from "Writing an LLVM Pass" -===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements two versions of the LLVM "InstCounter World" pass described
// in docs/WritingAnLLVMPass.html
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/CFG.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Casting.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
using namespace llvm;

#include <map>
#include <set>
#include <vector>
#include <iostream>
#include <algorithm>
#include <string>

#define DEBUG_TYPE "cs255"

// this method loops through the entire module for omp/kmpc calls
// - kmpc calls are removed
// - omp calls are replaced if appropriate
// - bop_ppr calls are added when a kmpc_fork is removed
void replace_calls(Module &M){
    errs() << "------original------\n";
    M.dump();
    int regIdx = 1; //used for adding new PPRs (and ordered regions?)
    Value *num_threads;
	for (Module::iterator F = M.begin(), ME = M.end(); F != ME; ++F){
		for(Function::iterator BB = F->begin(), FE = F->end(); BB != FE; ++BB){
			for(BasicBlock::iterator I = BB->begin(), BE = BB->end(); I != BE; ){
				if(isa<CallInst>(I)){
					std::string fn_name = I->getOperand(I->getNumOperands() - 1)->getName();
					if(fn_name == "__kmpc_fork_call"){ //remove omp fork and create bop_ppr
						//get bitcast to retrieve omp_outlined fn
                        User *bc_fn = dyn_cast<User>(I->getOperand(2));
						Function *par_fn = dyn_cast<Function>(bc_fn->getOperandList()->get());
                        LLVMContext &Context = F->getContext();
                        Type *intTy = Type::getInt32Ty(Context);
                        //add for loop to IR wrapping PPR, from 1 to sle arg to omp_set_num_threads
                        //  see README for planned instructions
                        //add _BOP_ppr_begin (do I need to do the branching that the macro does?)
                        Constant *function = M.getOrInsertFunction("_BOP_ppr_begin", intTy, intTy, (Type *)0);

                        ArrayRef<Value *> args({ConstantInt::getSigned(intTy, regIdx)});
                        CallInst *ppr_begin = CallInst::Create(function, args);
                        ppr_begin->insertBefore(&*I);
                        //add omp parallelized function
                        if(par_fn->arg_size() == 2){
                            function = M.getOrInsertFunction(par_fn->getName(), par_fn->getType(), intTy, intTy, (Type *)0);
                            args = ArrayRef<Value *>({ConstantInt::getSigned(intTy,1), ConstantInt::getSigned(intTy,1)});
                            CallInst::Create(function, args, "", &*I); // need to pass in loop counter to function
                        }else if(par_fn->arg_size() == 3){
                            
                            Argument * arg = &*(++(++(par_fn->arg_begin())));
                            function = M.getOrInsertFunction(par_fn->getName(), par_fn->getType(), intTy, intTy, arg->getType(), (Type *)0);
                            args = ArrayRef<Value *>({num_threads, num_threads, arg});
                            CallInst::Create(function, args, "", &*I);
                            for(Function::iterator bb = par_fn->begin(), be = par_fn->end(); bb != be; ++bb){
                                for(BasicBlock::iterator ii = bb->begin(), ie = bb->end(); ii != ie; ++ii){
                                    //if( load and arg is an operand)
                                    //    CallInst * call = CallInst::Create() //call BOP_record_read()
                                    //    call->insertBefore(ii);
                                    //if( store and arg is an operand)
                                    //    CallInst * call = CallInst::Create() //call BOP_record_write()
                                    //    call->insertAfter(ii);
                                }
                            }
                            
                        }else{
                            errs() << "more than one shared variable is not currently supported\n";
                        }
						//add _BOP_ppr_end
                        function = M.getOrInsertFunction("_BOP_ppr_end", Type::getVoidTy(Context), intTy, (Type *)0);
                        args = ArrayRef<Value *>({ConstantInt::getSigned(intTy, regIdx++)});
                        CallInst *ppr_end = CallInst::Create(function, args);
                        ppr_end->insertAfter(&*I);
						I = I->eraseFromParent();
                        continue;
					}else if(fn_name.find("__kmpc") == 0){ //remove remaining omp generated fn calls and any future uses
						for(auto U = I->user_begin(), UE = I->user_end(); U != UE; ++U){
							dyn_cast<Instruction>(*U)->eraseFromParent();
						}
						I = I->eraseFromParent();
                        continue;
					}else if(fn_name.find("omp") == 0){ //handle programmer added omp fns
                        if(fn_name == "omp_get_thread_num"){
                            LLVMContext &Context = F->getContext();
                            Type *intTy = Type::getInt32Ty(Context);
                            //Argument * tid = &*(I->getParent()->getParent()->arg_begin()); //this gets %.global_tid.
                            //LoadInst load_tid(intTy,tid); //this is failing at creating the LoadInst
                            Constant *function = M.getOrInsertFunction("getpid", intTy, (Type *)0);
                            CallInst *get_pid = CallInst::Create(function);
                            ReplaceInstWithInst(I->getParent()->getInstList(), I, get_pid);
                        }else if(fn_name == "omp_set_num_threads"){
                            num_threads = I->getOperand(0);
                            I = I->eraseFromParent();
                            continue;
                        }
                    }
                }
                ++I;
			}
		}
	}
    errs() << "------updated------\n";
    M.dump();
}

// this method loops through the entire module for omp/tid vars
// - .omp.stride and .omp.is_last are removed
// - .global_tid. and .bound_tid. are removed, along with cascading their register and its cascading uses
// - .omp.iv, .omp.lb, and .omp.ub are used for updating the loop counter
//   - these can be removed if the counter updating is restructured
void remove_vars(Module &M){
    errs() << "------original------\n";
    M.dump();
	for (Module::iterator F = M.begin(), ME = M.end(); F != ME; ++F){
		for(Function::iterator BB = F->begin(), FE = F->end(); BB != FE; ++BB){
			for(BasicBlock::iterator I = BB->begin(), BE = BB->end(); I != BE; ){
				if(isa<AllocaInst>(I)){
                    if(I->getName() == ".omp.stride" || I->getName() == ".omp.is_last"){ //remove unnecessary OMP vars
                        for(auto U = I->user_begin(), UE = I->user_end(); U != UE; ++U){
                            dyn_cast<Instruction>(*U)->eraseFromParent();
                        }
                        I = I->eraseFromParent();
                        continue;
                    }
                }else if(isa<StoreInst>(I)){
                    if(I->getOperand(0)->getName().find("_tid.") != std::string::npos){ //remove unecessary TID vars
                        Instruction *inst = dyn_cast<Instruction>(I->getOperand(1));
                        ++I;
                        for(auto U1 = inst->user_begin(), UE1 = inst->user_end(); U1 != UE1; ++U1){
                            for(auto U2 = U1->user_begin(), UE2 = U1->user_end(); U2 != UE2; ++U2){
                                dyn_cast<Instruction>(*U2)->eraseFromParent();
                            }
                            dyn_cast<Instruction>(*U1)->eraseFromParent();
                        }
                        inst->eraseFromParent();
                        continue;
                    }
                }
                ++I;
            }
        }
    }
    errs() << "------updated------\n";
    M.dump();
}

namespace {
	// OpenMPtoBOPtrans - converts OpenMP calls to BOP calls based on Blesel
	struct OpenMPtoBOPtrans : public ModulePass {
		static char ID; // Pass identification, replacement for typeid
		OpenMPtoBOPtrans() : ModulePass(ID) {}

		bool runOnModule(Module &M) override {
            replace_calls(M); //should this be split into "find" and "replace"?
                              //maybe split into thread -> process replace and API => API replace
            remove_vars(M);

			// Methodology for dumping is via the errs() stream
			// This requires output to stderr for the stream to
			// properly dump.
			std::cerr << std::endl;
			return true;
		}
	};
}

char OpenMPtoBOPtrans::ID = 0;
//Can I indicate when to schedule the pass here?
static RegisterPass<OpenMPtoBOPtrans> X("openmp-to-bop", "OpenMP to BOP Translation Pass");
