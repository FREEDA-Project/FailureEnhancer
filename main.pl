:- ['input.pl'].

allSuggested(Constraints) :-
    findall(Constraint, distinct(suggested(Constraint)), Constraints).

suggested(affinity(d(C,FC),d(S,FS))) :-
    deployedTo(C,FC,N), deployedTo(S,FS,M), dif(C,S), dif(N,M), 
    timeoutEvent(C,S,T),
    \+( congested(N,M,T); disconnected(N,T); disconnected(M,T) ).

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N), deployedTo(S,_,M), dif(C,S), dif(N,M),
    timeoutEvent(C,S,T),
    ( congested(N,M,T); disconnected(N,T) ).

suggested(avoid(d(S,FS),M)) :-
    deployedTo(C,_,N), deployedTo(S,FS,M), dif(C,S), dif(N,M),
    timeoutEvent(C,S,T),
    ( congested(N,M,T); disconnected(M,T) ).

suggested(avoid(d(C,FC),N)) :-
    deployedTo(C,FC,N),
    ( unreachable(C,T); internal(C,T) ),
    ( (overloaded(N,_,T), \+ race(N,_,C,FC,_,_,T)) ; disconnected(N,T)).

suggested(antiaffinity(d(C,FC),d(S,FS))) :-
    deployedTo(C,FC,N), 
    ( unreachable(C,T); internal(C,T) ),
    overloaded(N,R,T), 
    race(N,R,C,FC,S,FS,T).




congested(N,M,T) :- congestion(N,M,TI,TF), between(TI,TF,T).
congested(N,M,T) :- congestion(M,N,TI,TF), dif(N,M), between(TI,TF,T).

disconnected(N,T) :- disconnection(N,TI,TF), between(TI,TF,T).
overloaded(N,R,T) :- overload(N,R,TI,TF), between(TI,TF,T).

race(N,R,C,FC,S,FS,T) :-
    resourceIntensive(C,FC,R,N,T),
    resourceIntensive(S,FS,R,N,T), dif(S,C).

resourceIntensive(S,FS,R,N,T) :-
    deployedTo(S,FS,N), 
    highUsage(S,FS,R,TI,TF),
    between(TI,TF,T).