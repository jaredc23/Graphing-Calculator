main: main.o PIOControl.o DE1SoCfpga.o HDMI.o Graph.o
	g++ main.o PIOControl.o DE1SoCfpga.o HDMI.o Graph.o -o main

main.o: main.cpp Graph.h
	g++ -g -Wall -c main.cpp

Graph.o: Graph.cpp Graph.h
	g++ -g -Wall -c Graph.cpp

HDMI.o: HDMI.cpp HDMI.h
	g++ -g -Wall -c HDMI.cpp
	
PIOControl.o: PIOControl.cpp PIOControl.h
	g++ -g -Wall -c PIOControl.cpp

DE1SoCfpga.o: DE1SoCfpga.cpp DE1SoCfpga.h
	g++ -g -Wall -c DE1SoCfpga.cpp

clean:
	rm main.o Graph.o HDMI.o DE1SoCfpga.o PIOControl.o main
