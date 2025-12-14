cmake_minimum_required(VERSION 3.5)

add_sources(kappa++
	particle.cpp
	molecule.cpp
	atom.cpp)

install(FILES particles.hpp DESTINATION include/kappa++)
install(FILES particle.hpp  DESTINATION include/kappa++)
install(FILES molecule.hpp  DESTINATION include/kappa++)
install(FILES atom.hpp      DESTINATION include/kappa++)
