all: euler

euler: *.hs
	ghc -o euler EulerInputs.hs ProjectEuler.hs EulerMain.hs

clean:
	\rm -f *.hi *.o ${MAIN_TARGET}
