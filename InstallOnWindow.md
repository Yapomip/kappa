# Zero
ну весело конечно, но собирать под виндой....
хз, проше установить линукс и сделать это там

# First
You need:
- из MinGW
- - Cmake
- - gcc (я использовал его хз попробуй может и с вижул студио тоже соберется)
- создать дирректорию kappa/dependencies
- скачиваем OpenBLAS - release, его пихать в dependencies(название типа OpenBLAS...-x64.zip; woa - windows on arm)
- скачиваем Armadillo - исходники их просто скачать, тоже в dependencies

# Собираем Armadillo
PATH - путь к kappa, должен быть абсолютный
PATH\dependencies\OpenBLAS\lib - здесь должна лежать lib от openblas

0) малоли кто не умеет)))
встаем в консоли в PATH\dependencies\armadillo-...\
1) cmake -B build \
    -DCMAKE_SYSTEM_LIBRARY_PATH="PATH\dependencies\OpenBLAS\lib" \
    -D OPENBLAS_PROVIDES_LAPACK=true -D CMAKE_INSTALL_PREFIX="PATH\dependencies\arma" \
    -D CMAKE_CXX_FLAGS="-DARMA_USE_LAPACK -DARMA_USE_BLAS"
2) cmake --build build --config Release --parallel 8
3) cmake --install build --prefix PATH\dependencies\arma

после этого действа в
PATH\dependencies\arma - лежит собранная armadillo

# Собираем kappa

0) встаем в PATH
1) cmake -B build
2) cmake --build build --config Release
На этом моменте если она собралась без ошибок уже можно ее использовать просто подлючив через add_subdirrectory в соседнем проекте
3) cmake --install build --prefix PATH\install

все теперь kappa можно подключать через и find_package

если будут ошибки, решайте их сами)))


cmake D:\\!proga_institut\\2025_spbu_coursework\\rust\\kappa_rust\\../kappa_c_wrap -B D:\\!proga_institut\\2025_spbu_coursework\\rust\\kappa_rust\\target\\debug\\build\\kappa_rust-d8dd1b108d3609d7\\out\\build -G "Visual Studio 17 2022" -Thost=x64 -Ax64 -DCMAKE_INSTALL_PREFIX=D:\\!proga_institut\\2025_spbu_coursework\\rust\\kappa_rust\\target\\debug\\build\\kappa_rust-d8dd1b108d3609d7\\out -DCMAKE_C_FLAGS=" -nologo -MD -Brepro" -DCMAKE_C_FLAGS_DEBUG=" -nologo -MD -Brepro" -DCMAKE_CXX_FLAGS=" -nologo -MD -Brepro" -DCMAKE_CXX_FLAGS_DEBUG=" -nologo -MD -Brepro" -DCMAKE_ASM_FLAGS=" -nologo -MD -Brepro" -DCMAKE_ASM_FLAGS_DEBUG=" -nologo -MD -Brepro" -DCMAKE_BUILD_TYPE=Debug

cmake --build D:\\!proga_institut\\2025_spbu_coursework\\rust\\kappa_rust\\target\\debug\\build\\kappa_rust-d8dd1b108d3609d7\\out\\build --target install --config Debug --parallel 16