cmake_minimum_required(VERSION 3.5)

add_sources(kappa++
	numeric.cpp)

install(FILES numeric.hpp DESTINATION include/kappa++)
install(FILES constants.h DESTINATION include/kappa++)
