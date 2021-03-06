QD_ROOT=/usr/local/qd-2.3.9
GQD_HOME=/usr/local/gqd_1_2
SDK_HOME=/usr/local/cuda/sdk

all: run_ped_d run_ped_dd run_ped_qd

run_ped_d:
	@-echo ">>> compiling kernels ..."
	nvcc --define-macro precision=d -I./DefineTypesD \
	     -I$(GQD_HOME)/inc -I$(SDK_HOME)/C/common/inc \
             -I/usr/local/cuda/include \
             -c ped_kernelsT.cu -arch=sm_13
	@-echo ">>> compiling utilities ..."
	g++ -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include -c gqd_qd_util.cpp
	@-echo ">>> compiling run_ped ..."
	g++ --define-macro precision=d -I./DefineTypesD -c run_ped.cpp \
            -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include
	@-echo ">>> linking ..."
	g++ -I$(GQD_HOME)/inc -I$(QD_ROOT)/include \
		ped_kernelsT.o run_ped.o gqd_qd_util.o \
		$(QD_ROOT)/src/libqd.a -o run_ped_d \
            -lcuda -lcutil_x86_64 -lcudart \
            -L/usr/local/cuda/lib64 -L$(SDK_HOME)/C/lib

run_ped_dd:
	@-echo ">>> compiling kernels ..."
	nvcc --define-macro precision=dd -I./DefineTypesDD \
	     -I$(GQD_HOME)/inc -I$(SDK_HOME)/C/common/inc \
             -I/usr/local/cuda/include \
             -c ped_kernelsT.cu -arch=sm_13 --ptxas-options=-v
	@-echo ">>> compiling utilities ..."
	g++ -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include -c gqd_qd_util.cpp
	@-echo ">>> compiling run_ped ..."
	g++ --define-macro precision=dd -I./DefineTypesDD -c run_ped.cpp \
            -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include
	@-echo ">>> linking ..."
	g++ -I$(GQD_HOME)/inc -I$(QD_ROOT)/include \
		ped_kernelsT.o run_ped.o gqd_qd_util.o \
		$(QD_ROOT)/src/libqd.a -I./DefineTypesDD -o run_ped_dd \
            -lcuda -lcutil_x86_64 -lcudart \
            -L/usr/local/cuda/lib64 -L$(SDK_HOME)/C/lib

run_ped_qd:
	@-echo ">>> compiling kernels ..."
	nvcc --define-macro precision=qd -I./DefineTypesQD \
	     -I$(GQD_HOME)/inc -I$(SDK_HOME)/C/common/inc \
             -I/usr/local/cuda/include \
             -c ped_kernelsT_qd.cu -arch=sm_13 --ptxas-options=-v
	@-echo ">>> compiling utilities ..."
	g++ -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include -c gqd_qd_util.cpp
	@-echo ">>> compiling run_ped ..."
	g++ --define-macro precision=qd -I./DefineTypesQD -c run_ped.cpp \
            -I/usr/local/cuda/include -I$(GQD_HOME)/inc \
            -I$(QD_ROOT)/include
	@-echo ">>> linking ..."
	g++ -I./DefineTypesQD -I$(GQD_HOME)/inc -I$(QD_ROOT)/include \
		ped_kernelsT_qd.o run_ped.o gqd_qd_util.o \
		$(QD_ROOT)/src/libqd.a -o run_ped_qd \
            -lcuda -lcutil_x86_64 -lcudart \
            -L/usr/local/cuda/lib64 -L$(SDK_HOME)/C/lib

clean:
	test -z "run_ped_d" || rm -f run_ped_d
	test -z "run_ped_dd" || rm -f run_ped_dd
	test -z "run_ped_qd" || rm -f run_ped_qd
	rm -f *.o
