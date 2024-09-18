% Deployment
deployedTo(frontend, large, n1).
deployedTo(backend, medium, n2).
deployedTo(database, large, n2).
deployedTo(frontend2, medium, n3).

% Frontend failed to contact the backend
timeoutEvent(frontend, backend, 8).

% Backend internal failure and database unreachable
internal(backend, 7).
unreachable(database, 6).

% n2 overloaded and n3 disconnected
overloaded(n2, cpu, 5, 10).
disconnected(n3, 3, 4).

% Network congestion between n2 and n3 affecting communication
congested(n2, n3, 6, 9).
