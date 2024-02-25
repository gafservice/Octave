## Copyright (C) 2022-2024 Pablo Alvarado
## EL5857 Aprendizaje automático
## Tarea 2

## Example for creating and showing the sensor raw data

## Use for the experiments just 0,1% of the total available data.
[X,z] = gendata(0.001);

plot3(X(:,1),X(:,2),z(:),".");
xlabel("x")
ylabel("y")
zlabel("z")
set(gca, 'cameraviewanglemode', 'manual')

