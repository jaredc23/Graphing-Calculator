/* 
 * @file Graph.h
 * @author  Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 2 2021
 * @brief	This is the .h file in which the graph class is prototyped, it also contains useful constants.
 */

#ifndef GRAPH_H
#define GRAPH_H

#include "HDMI.h"

#define black 0   //Define all of the color constants 
#define maroon 1   
#define green 2    
#define olive 3    
#define navy 4     
#define purple 5   
#define teal 6     
#define silver 7   
#define gray 8
#define red 9
#define lime 10
#define yellow 11
#define blue 12
#define fuchsia 13
#define aqua 14
#define white 15

#define no_grid 0 //Define constants for grid types
#define dot_grid 1
#define line_grid 2

class Graph : public HDMI
{
    public:
        Graph(); //Default constructor, initializes window to [-10, 10] for x and y axis.
        Graph(double Xmin, double Xmax, double Ymin, double Ymax); //Constructor that sets window dimensions
        void clearScreen(int grid); //Clear screen function, takes parameter to draw grid
        void drawFunction(double (*function)(double), double lineWidth, int color, double delay_seconds); //Graphs a function, takes a pointer to a function, the lineWidth, the color, and if the graph should be drawn with a delay
    private:
        double map(double x, double in_min, double in_max, double out_min, double out_max); //Map function to map ranges
        int xtopixel(double x); //Converts an x coordinate to a pixel coordinate
        int ytopixel(double y); //Converts a y coordinate to a pixel coordinate
        double xmin, xmax, ymin, ymax; //Constants for the coordinate max and min dimensions
};

#endif