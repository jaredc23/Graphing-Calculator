/* 
 * @file    main.cpp
 * @author	Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 31 2021
 * @brief	This is the main file to demo the Graphing application using the FPGA
 */

#include "Graph.h"
#include <iostream>
using namespace std;

#include <math.h> //Used for SQRT function

double porabola(double x){return x*x;} //x^2 Porabola

double square_root(double x){return sqrt(x);} //sqrt(x) Function

double one_over_neg_x(double x){return -1/x;} // -1/x Function

double cubic(double x){return x*x*x;} //x^3 function

int main()
{
    Graph graph(-10, 10, -10, 10); // Create a graph object with screen since -10 to 10 on y and x axis
    graph.clearScreen(line_grid); //Clear the screen with grid of grey lines
    graph.drawFunction(&porabola, 2, blue, 0); //Graph the porabola, Line width 2, no delay in graphing
    graph.drawFunction(&square_root, 2, red, 0); //Graph square root, LW 2, red color, no delay
    graph.drawFunction(&one_over_neg_x, 2, lime, 0); //Graph -1/x with LW 2, and no delay in graphing
    graph.drawFunction(&cubic, 2, aqua, .025); //Graph cubic, LW 2, .025 sec delay between each pixel
}
