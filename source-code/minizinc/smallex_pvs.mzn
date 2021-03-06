% A really simplistic over-constrained model
% X: {x,y,z} D_i = {1,2,3}, i in X
%    * c1: x + 1 = y 
%    * c2: z = y + 2
%    * c3: x + y <= 3
% -------------------------------------------

%include "minisearch.mzn"; % include the search minisearch lite
include "soft_constraints.mzn"; % model additions for soft constraint business
include "spd_worse.mzn"; % the actual isBetter predicate
include "tpd_worse.mzn"; % the actual isBetter predicate
%include "pvs_search.mzn"; % search strategies for SPD better
include "cr_types.mzn";
include "pvs_spd.mzn";

%include "pvs_weighted.mzn";
% choose aggregator for pvs-weighted: sumAggregator, maxAggregator, minAggregator
%include "sum_aggregator.mzn";

% soft constraint specific for this model
nScs = 3;

% ==============================================================
% Now the actual model begins -> add soft constraints
var 1..3: x; 
var 1..3: y;
var 1..3: z;

constraint x + 1 = y <-> satisfied[1];
constraint z = y + 2 <-> satisfied[2];
constraint x + y <= 3 <-> satisfied[3];

% for debug purposes 
%constraint isWorse({1,2,3}, violatedScs);
%constraint isWorse({1,2}, violatedScs);
%constraint isWorse({1}, violatedScs);
%constraint isWorse({2,3}, violatedScs);
%constraint isWorse({2}, violatedScs);

solve 
:: int_search(satisfied, input_order, indomain_min, complete)
minimize penSum;
%search time_limit(3000, strictlyBetterBAB(violatedScs)) /\ if hasSol() then print() else print("No solution found\n") endif;
%search time_limit(3000, strictlyBetterBAB_TPD(violatedScs)) /\ if hasSol() then print() else print("No solution found\n") endif;
%search time_limit(3000, onlyNotDominatedBAB(violatedScs)) /\ if hasSol() then print() else print("No solution found\n") endif;
%satisfy;

output ["Obj: \(penSum) by violating {\(violatedScs) } : x -> \(x), y  -> \(y), z -> \(z)"];
