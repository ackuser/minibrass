% voting 2
include "minisearch.mzn";

function ann: postGetBetter() = 
  let {
    var 0..1: aLikes;
    var 0..1: bLikes;
    var 0..1: cLikes;
    %array[1..3] of var bool: approvals;

  } in
  post(
      (
      aLikes = bool2int(betterForA(choice, sol(choice))) /\
      bLikes = bool2int(betterForB(choice, sol(choice))) /\
      cLikes = bool2int(betterForC(choice, sol(choice)))
      ) /\
      ( % the number of agents that prefer the next solution over the current one 
      bool2int(betterForA(choice, sol(choice)))
      + bool2int(betterForB(choice, sol(choice)))
      + bool2int(betterForC(choice, sol(choice))) 
      )
      >  % exceeds
      ( % the number of agents that dislike the next solution 
      bool2int(betterForA(sol(choice), choice))
      + bool2int(betterForB(sol(choice), choice))
      + bool2int(betterForC(sol(choice), choice))
      )
  );
  
predicate betterForA(var OPTIONS: o1, var OPTIONS: o2) = 
let {
  constraint table([o1,o2], [| 3, 1 | 3, 2 | 1, 2 |] );
} in
(
 true
);

predicate betterForB(var OPTIONS: o1, var OPTIONS: o2) = 
let {
  constraint table([o1,o2], [| 2, 1 | 2, 3 | 1, 3 |] );
} in
(
  true
);

predicate betterForC(var OPTIONS: o1, var OPTIONS: o2) = 
let {
  constraint table([o1,o2], [| 3, 2 | 3, 1 | 2, 1 |] );
} in
(
  true
);

function ann: pvs_Condorcet_BAB() =
       repeat(
           if next() then 
                 print("Intermediate solution:") /\ print() /\
                 commit() /\ postGetBetter()
           else break endif
       );

set of int: OPTIONS = 1..3;

var OPTIONS: choice;

solve search pvs_Condorcet_BAB();

output["choice = \(choice)"];