/*********************************************
 * OPL 12.2 Model
 * Author: Luca Carlone
 * Creation Date: 2017-10-16
 *********************************************/
execute CPX_PARAM {
 //	cplex.epgap = 0.01; //25;
 // cplex.tilim = 2000;
 // cplex.nodesel = 0; // Branch depth first, so we should find feasible solution quickly and use less memory
}

// Read input data
int n = ...;
int m = ...;

// read matrices and vectors
float A[1..m,1..n] = ...;
float b[1..m] = ...;
float c[1..n] = ...;

// Optimization variables
dvar boolean x[1..n];

/** OPTIMIZATION PROBLEM **/
minimize sum(i in 1..n) ( c[i] * x[i] ); 

subject to{

// Coherence for odometric measurements
forall(i in 1..m){
 sum(j in 1..n) ( A[i,j] * x[j] ) <= b[i]; 
}

} // end of constraints

/** PRINT RESULTS TO FILE OUTPUT.TXT**/
range loops = 1..n;
execute{
 var ofile = new IloOplOutputFile('output-x.txt');
 for(var o in loops){
   ofile.write(x[o]);
   ofile.write(" ");
 }   
 ofile.close();
}  
 