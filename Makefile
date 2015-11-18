all: linux qurt

define df_cmake_generate
mkdir -p build_$(1) && cd build_$(1) && cmake -Wno-dev .. -DDF_TARGET=$(1) -DCMAKE_TOOLCHAIN_FILE=$(2)
endef

define df_build
	$(call df_cmake_generate,$(1),cmake/toolchains/Toolchain-$(1).cmake)
	cd build_$(1) && make
endef

linux nuttx:
	$(call df_build,$@)

external/dspal:
	cd external && git clone https://github.com/ATLFlight/dspal

dspal_sync: external/dspal
	cd external/dspal && git pull

qurt: dspal_sync
	$(call df_build,$@)
	
clean:
	rm -rf build_*
