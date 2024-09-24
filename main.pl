:- ['input.pl'].

allSuggested(Constraints) :-
    findall(Constraint, suggested(Constraint), Cs),
    sort(Cs, Constraints). % remove duplicates

suggested(affinity(d(C,FC),d(S,SF))) :-
    deployedTo(C,FC,N), deployedTo(S,SF,M), dif(C,S), dif(N,M), 
    \+ networkCongestion(N,M,TI,TF),
    \+ disconnected(M, TI, TF),
    timeoutEvent(C,S,TE), between(TI,TF,TE).

suggested(antiaffinity(d(C,FC),d(S,SF))) :-
    deployedTo(C,FC,N), failureEvent(C,TE),
    overloaded(N,R,TI,TF), between(TI,TF,TE),
    race(R, C, FC, S, FS, TI, TF).

race(R, C, FC, S, FS, TI, TF) :-
    resourceIntensive(C,FC,R,N,TI,TF),
    resourceIntensive(S,FS,R,N,TI,TF), dif(S,C).

resourceIntensive(S, FS, R, N, TI, TE) :-
    deployedTo(S, FS, N), 
    highUsage(S, FS, R, TI1, TE1),
    TI1 =< TI, TE =< TE1.

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N),
    anomaly(N,TI,TF), 
    failureEvent(C,TE), between(TI,TF,TE),  % between(TI, TF, TE) <=> TI ≤ TE ≤ TF
    \+ race(_, C, FC, _, _, TI, TF).

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N), deployedTo(S,_,M), dif(C,S), dif(N,M),
    networkCongestion(N,M,TI,TF),
    timeoutEvent(C,S,TE), between(TI,TF,TE).
   
failureEvent(S,T) :- unreachable(S,T); internal(S,T).

anomaly(N,TI,TF) :- overloaded(N,_,TI,TF); % Resource \in {CPU,RAM,HDD,BW}
                    disconnected(N,TI,TF). 

networkCongestion(N,M,TI,TF) :- congested(N,M,TI,TF).
networkCongestion(N,M,TI,TF) :- congested(M,N,TI,TF), dif(N,M).