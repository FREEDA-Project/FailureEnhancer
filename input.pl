% Deployment
deployedTo(frontend, large, n1).
deployedTo(backend, medium, n2).
deployedTo(database, large, n2).

% Backend internal failure and database unreachable
unreachable(database, 6).
internal(backend, 7).

% frontend failed to contact the backend
timeoutEvent(frontend, backend, 8).

%  highUsage(S, FS, R, TI, TF),
highUsage(backend, medium, cpu, 6, 9).
highUsage(database, large, cpu, 5, 9).
overload(n2, cpu, 6, 9).

% Network congestion between n1 and n2 affecting communication
congestion(n1, n2, 7, 9).
disconnection(n1, 4, 6).