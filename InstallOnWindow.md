# Zero
ну весело конечно, но собирать под виндой....
хз, проше установить линукс и сделать это там

# First
You need:
- можно взять MinGW(проверено для этого)
- - Cmake
- - gcc (я использовал его хз попробуй может и с вижул студио тоже соберется)
- создать дирректорию kappa/dependencies
- скачиваем OpenBLAS - release, его пихать в dependencies(название типа OpenBLAS...-x64.zip; woa - windows on arm)
- скачиваем Armadillo - исходники на github(подробнее ниже) их просто скачать, тоже в dependencies
- скачиваем yaml-cpp - исходники на github(подробнее ниже) их просто скачать, тоже в dependencies

PATH - абсолютный путь к kappa 

# Собираем yaml-cpp
0) встаем в консоли в PATH\dependencies\yaml-cpp\
1) cmake -B build
2) cmake --build build --config Release --parallel 8
3) cmake --install build --prefix dependencies\yaml

# Собираем Armadillo
PATH\dependencies\OpenBLAS\lib - здесь должна лежать lib от openblas

0) встаем в консоли в PATH\dependencies\armadillo-...\
1) cmake -B build \
    -D CMAKE_SYSTEM_LIBRARY_PATH="PATH\dependencies\OpenBLAS\lib" \
    -D OPENBLAS_PROVIDES_LAPACK=true -D CMAKE_INSTALL_PREFIX="PATH\dependencies\arma" \
    -D CMAKE_CXX_FLAGS="-DARMA_USE_LAPACK -DARMA_USE_BLAS"
2) cmake --build build --config Release --parallel 8
3) cmake --install build --prefix dependencies\arma

после этого действа в
PATH\dependencies\arma - лежит собранная armadillo

# Собираем kappa
yaml-cpp_DIR, OpenBLAS_DIR, Armadillo_DIR - пути к собранным библиотека по дефолту забиты как здесь, но если вы их установили куда то в другое место то через "cmake -B build -D ...=..." можно их становить(в теории не, тестировалось, см CmakeList.txt там где find_package)

0) встаем в PATH
1) cmake -B build
2) cmake --build build --config Release
На этом моменте если она собралась без ошибок уже можно ее использовать просто подлючив через add_subdirrectory в соседнем проекте
3) cmake --install build --prefix install

все теперь kappa можно подключать через и find_package
тесты и примеры на винде не собирались, но подключался внешний проект, так что где то это работает)))

если будут ошибки, удачи)))
