/* 
 * @file Graph.cpp
 * @author	Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 31 2021
 * @brief	This is the .cpp file in which the Graph class is made, implements the Graph class's methods.
 */


#include <iostream>
#include <math.h>
#include <unistd.h>

#include "Graph.h"

//Default constructor which initializes the screen to a window of [-10, 10]
Graph::Graph()
{
    xmin = -10; //Set to default values of -10 to 10 square
    xmax = 10;
    ymin = -10;
    ymax = 10;
}

//Constructor to set the graph window
Graph::Graph(double Xmin, double Xmax, double Ymin, double Ymax)
{
    xmin = Xmin; //Sets the graph window.
    xmax = Xmax;
    ymin = Ymin;
    ymax = Ymax;
}

//Clears screen and draws the grid according to the parameter.
void Graph::clearScreen(int grid)
{

    int pixelx0 = xtopixel(0); //Get the pixel coordinates of the x and y axis
    int pixely0 = ytopixel(0);

    writeScreen(white); //Write the screen white

    if(grid == 1)
    {   
        for(double i = 0; i <= xmax; i += 1) //Draws a dot on the grid every 1 unit
            for(double j = 0; j <= ymax; j += 1)
                writePixel(xtopixel(i), ytopixel(j), gray);

        for(double i = 0; i >= xmin; i -= 1)
            for(double j = 0; j >= ymin; j -= 1)
                writePixel(xtopixel(i), ytopixel(j), gray);
    }
    else if(grid == 2) //Draws a grid of grey lines every one unit.
    {
        for(double i = 0; i <= xmax; i += 1)
            for(int j = 0; j <= 480; j++)
                    writePixel(xtopixel(i), j, silver);
        for(double i = 0; i <= ymax; i += 1)
            for(int j = 0; j <= 640; j++)
                    writePixel(j, ytopixel(i), silver);

        for(double i = 0; i >= xmin; i -= 1)
            for(int j = 0; j <= 480; j++)
                    writePixel(xtopixel(i), j, silver);
        for(double i = 0; i >= ymin; i -= 1)
            for(int j = 0; j <= 640; j++)
                    writePixel(j, ytopixel(i), silver);
    }


    for(int i = 0; i < 480; i++) //Draw the y axis
    {
        writePixel(pixelx0, i, 0);
    }

    for(int i = 0; i < 640; i++) //Draw the x axis
    {
        writePixel(i, pixely0, 0);
    }
}


void Graph::drawFunction(double (*function)(double), double lineWidth, int color, double delay_seconds)
{
    for(double x = xmin; x <= xmax; x+= (xmax - xmin)/640.0){
        
        int pixelx = xtopixel(x);
        double yvalue = function(x);
        if(!isnan(yvalue)) //Make sure function is not undefined, can cause odd behaviors
        {
            int pixely = ytopixel(yvalue);

            if(pixely >= 0 && pixely <= 480)
            {
                for(int i = pixelx - lineWidth; i <= pixelx + lineWidth; i++) //Draws a group of pixels, depending on the width
                    for(int j = pixely - lineWidth; j <= pixely + lineWidth; j++)
                        writePixel(i, j, color);
                
                usleep(delay_seconds*1000000); //This line adds delay to make the function appear like it is drawing
            }
        }
    }
}

//Map function to map pixel values from the coordinate system to the pixels on the screen
double Graph::map(double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

//Maps an x coordinate to a pixel on the screen
int Graph::xtopixel(double x)
{
    return map(x, xmin, xmax, 0, 640);
}

//Maps a ypixel to a pixel on the screen
int Graph::ytopixel(double y)
{
    return 480 - map(y, ymin, ymax, 0, 480); //Need to subtract from 480, since y coordinate of the monitor is the top left, not bottom left
}