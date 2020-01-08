oldpath = path;
addPathList = ["swipt-mimo", "src", "datasets", "functions"];
for pathName = addPathList
  path(oldpath, char(pathName));
end
