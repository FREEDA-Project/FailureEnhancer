allSuggested(Constraints) :-
    findall(Constraint, suggested(Constraint), Cs),
    sort(Cs, Constraints). % remove duplicates

suggested(affinity(d(C,FC),d(S,SF))) :-
    deployedTo(C,FC,N), deployedTo(S,SF,M), dif(N,M),
    timeoutEvent(C,S,_).
    
suggested(antiaffinity(d(C,FC),d(S,SF))) :-
    failureEvent(C,TE),
    overloaded(N,_,TI,TF), between(TI,TF,TE),
    deployedTo(C,FC,N), deployedTo(S,SF,N).

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N),
    anomaly(N,TI,TF), 
    failureEvent(C,TE), between(TI,TF,TE).  % between(TI, TF, TE) <=> TI ≤ TE ≤ TF

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N), deployedTo(S,_,M), dif(N,M),
    networkCongestion(N,M,TI,TF), % Hp: networkCongestion(N,M) -> networkCongestion(M,N)
    timeoutEvent(C,S,TE), between(TI,TF,TE).
    
failureEvent(S,T) :- unreachable(S,T); internal(S,T).

anomaly(N,TI,TF) :- overloaded(N,_,TI,TF); % Resource \in {CPU,RAM,HDD,BW}
                    disconnected(N,TI,TF). 
