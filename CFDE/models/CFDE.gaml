/***
* Name: CFDE
* Author: sklab
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model CFDE

/* Insert your model definition here */

global {
	string algorithm <- "A*" among: ["A*", "Dijkstra", "JPS", "BF"] parameter: true;
	int neighborhood_type <- 8 among:[4,8] parameter: true;
}


grid cell width: 50 height: 50 neighbors: 8 optimizer: algorithm {
	bool is_obstacle <- flip(0.2);
	rgb color <- is_obstacle ? #black : #white;
}




species goal {
	aspect default { 
		draw circle(0.5) color: #red;
	}
}  
	
	  
species people skills: [moving] {
	goal target;
	float speed <- float(3);
	aspect default {
		draw circle(0.5) color: #green;
		if (current_path != nil) {
			draw current_path.shape color: #red;
		}
	}
	
	reflex move when: location != target{
		//We restrain the movements of the agents only at the grid of cells that are not obstacle using the on facet of the goto operator and we return the path
		//followed by the agent
		//the recompute_path is used to precise that we do not need to recompute the shortest path at each movement (gain of computation time): the obtsacles on the grid never change.
		do goto (on:(cell where not each.is_obstacle), target:target, speed:speed, recompute_path: false);
		
		//As a side note, it is also possible to use the path_between operator and follow action with a grid
		//Add a my_path attribute of type path to the people species
		//if my_path = nil {my_path <- path_between((cell where not each.is_obstacle), location, target);}
		//do follow (path: my_path);
	}
}










experiment goto_grid type: gui {
	output {
		display objects_display {
			grid cell lines: #black;
			//species goal aspect: default ;
			//species people aspect: default ;
		}
	}
} 