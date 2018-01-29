#define CONC false         //don't include concentration on the boundary
#define BULKPOL true          //include internal active fluid
#define WALLS false         //don't include walls
const int Lx = 120;         //number of point in x direction
const int Ly = 120;          //number of points in y direction
 
double ST=5;    //bare surface tension
double Zeta=5;    //bulk activity
double K=0.25;        //elastic constant
