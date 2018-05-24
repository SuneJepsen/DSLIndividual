/*
 * generated by Xtext 2.13.0
 */
package com.metagamedsl.individual.validation
import com.metagamedsl.individual.metaGameLanguage.Object
import org.eclipse.xtext.validation.Check
import com.metagamedsl.individual.metaGameLanguage.MetaGameLanguagePackage
import com.metagamedsl.individual.metaGameLanguage.Game
import com.metagamedsl.individual.metaGameLanguage.Declaration
import com.metagamedsl.individual.metaGameLanguage.Location
import com.metagamedsl.individual.metaGameLanguage.Property
import java.util.ArrayList
import java.util.List
import com.metagamedsl.individual.metaGameLanguage.BoolExp
import com.metagamedsl.individual.metaGameLanguage.NumberExp
import com.metagamedsl.individual.metaGameLanguage.Proposition
import com.metagamedsl.individual.metaGameLanguage.And
import com.metagamedsl.individual.metaGameLanguage.Or
import com.metagamedsl.individual.metaGameLanguage.Comparison
import com.metagamedsl.individual.metaGameLanguage.Expression
import com.metagamedsl.individual.metaGameLanguage.Add
import com.metagamedsl.individual.metaGameLanguage.Sub
import com.metagamedsl.individual.metaGameLanguage.Mult
import com.metagamedsl.individual.metaGameLanguage.Div
import com.metagamedsl.individual.metaGameLanguage.Parenthesis
import com.metagamedsl.individual.metaGameLanguage.LocalVariable
import com.metagamedsl.individual.metaGameLanguage.Variable
import java.util.regex.Pattern
import java.util.Map
import java.util.LinkedList
import java.util.HashMap
import com.metagamedsl.individual.metaGameLanguage.ObjectDeclaration
import com.metagamedsl.individual.metaGameLanguage.LocationDeclaration

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
 
	class GraphNode {

        private String name;
  

        new (String name) {
            this.name = name;

        }


    } 
 
class MetaGameLanguageValidator extends AbstractMetaGameLanguageValidator {
	
		
	/*
	 * number test = Agent1.path   
	 * 
	 * Validate on global properties
	 * "path" property should then exist on Agent1 else fail
	 */
	@Check
	def checkGameFieldObjectProperty(Game game){
		// Loop all game properties
		for(var y = 0; y < game.fields.length; y++){// Start for # 1 
			// Get property variables e.g Agent1.score, Agent2.score
			var vars = game.fields.get(y).getVariables
			// Loop through the found property variables
			for(var i = 0; i < vars.length; i++){// Start for # 2 
				if(vars.get(i) instanceof LocalVariable){
					var localVariable = vars.get(i) as LocalVariable
					// Do a look to see if the property exist on object
					for(var g = 0; g < game.getDeclarations.length; g++){// Start for # 1 
						game.getDeclarations.get(g).validateFieldProperty(localVariable)
						
					}// End for # 0 				
						
				}
			} // End for # 2
		}// End for # 1 
	}
		/*
	 * number test = Agent1.path   
	 * 
	 * Validate on global properties
	 * Agent1 should exist
	 */
	@Check
	def checkGameFieldObjectExist(Game game){
 
	}	
	
	
	
	/*
 	* 	Object Agent1 (0,0) Agent2(1,0)   
		    truth value isAgent = true     
		  	number path = 0  
		Object Agent3 (0,0)   
		    truth value isAgent = true    
		  	number path = Agent1.score
	  	* 
	  	*Validate on locale object properties
	  	* Agent1.score , score should exist on Agent1 properties  
	 * 
	 */
	@Check
	def chekObjectProperty(Game game){
		// Loop all game properties
		for(var y = 0; y < game.declarations.length; y++){// Start for # 1 		
			if(game.declarations.get(y) instanceof Object){
				var object = (game.declarations.get(y) as Object)				
				for(var x = 0; x < object.properties.length; x++){// Start for # 2	
					var vars = object.properties.get(x).getVariables
					for(var i = 0; i < vars.length; i++){// Start for # 3 
						if(vars.get(i) instanceof LocalVariable){
							var localVariable = vars.get(i) as LocalVariable
							// Do a look to see if the property exist on object
							for(var g = 0; g < game.getDeclarations.length; g++){// Start for # 4 
								game.getDeclarations.get(g).validateFieldProperty(localVariable)								
							}// End for # 4 				
								
						}
					} // End for # 3			
				}
			} // End for # 2
		}// End for # 1
	}
	
	def dispatch void validateFieldProperty(Object object, LocalVariable localVariable){
		 try {
	   
			var objectName = localVariable.var_local // Agent1
			var propertyName = localVariable.var_prop.name // isAgent			
			
			// Loop over all object names on object
			var match = false
			for(var x = 0; x < object.declarations.length; x++){// Start for # 1
				
							
				// Check if there is a match
				if(object.declarations.get(x).name == objectName){		
					
					for(var y = 0; y < object.properties.length; y++){// Start for # 2	
						if(object.properties.get(y).name == propertyName){
							match = true	
						}
					} // End for # 2
					if(!match){
						error("Object does not have property "+  propertyName, localVariable  ,MetaGameLanguagePackage.Literals.LOCAL_VARIABLE__VAR_LOCAL);
						error("Property do not exist on object "+ objectName + "." + propertyName,localVariable  ,MetaGameLanguagePackage.eINSTANCE.localVariable_Var_prop);					
					}
				}
			}// End for # 1	
	
	 	} 
	 	catch (IllegalArgumentException e) {
	 		System.out.println(e);
	    }
	}
	def dispatch void validateFieldProperty(Location object, LocalVariable localVariable){
			//System.out.println("validateFieldProperty2")	
	}
    def List<Expression> getVariables(Property p) {
    	switch p {
    		BoolExp: p.bool_exp.getBoolVars
    		NumberExp: p.math_exp.getMathVars
    		default: throw new Error("Invalid expression")
    	}
    }
	
    def List<Expression> getBoolVars(Proposition p) {
    	var list = new ArrayList<Expression>()
    	switch p {
    		And: { 	list.addAll(p.left.getBoolVars)
	    			list.addAll(p.right.getBoolVars) }
	      	Or: { 	list.addAll(p.left.getBoolVars)
	    			list.addAll(p.right.getBoolVars) } 
	      	Comparison: { 	list.addAll(p.left.getMathVars)
	    					list.addAll(p.right.getMathVars) }
    	}
    	list
    }
        
    def List<Expression> getMathVars(Expression e) {
    	var list = new ArrayList<Expression>()
    	switch e {
    		Add: { 	list.addAll(e.left.getMathVars)
	    			list.addAll(e.right.getMathVars) }
	    	Sub: { 	list.addAll(e.left.getMathVars)
	    			list.addAll(e.right.getMathVars) }
	    	Mult: { list.addAll(e.left.getMathVars)
	    			list.addAll(e.right.getMathVars) }
	    	Div: { 	list.addAll(e.left.getMathVars)
	    			list.addAll(e.right.getMathVars) }
	    	Parenthesis: list.addAll(e.exp.getMathVars)
	        LocalVariable: list.add(e) // Ex: parameters to varProperty
	        Variable: list.add(e) //
	    }
	    list
    }
	
	/*
	 * Object Agent1 (0,0) Agent2(1,0)   
	    truth value isAgent = true  
	    truth value isAgent = true    
	  	number path = 0
	  	* 
	  	* Two properties with same name should not be allowed
	 */
	@Check 
	def checkConflictProperty(Game game){
		for(var y = 0; y < game.getDeclarations.length; y++){// Start for # 1 
			game.getDeclarations.get(y).validateProperty;
		}// End for # 0  
	}
	def dispatch void validateProperty(Object object){
		var List<String> propertyList = new ArrayList();
		for(var y = 0; y < object.properties.length; y++){// Start for # 1		 
			if( object.properties.get(y) instanceof BoolExp){
				if(propertyList.contains(object.properties.get(y).name)){
					error("Property " + ( object.properties.get(y) as BoolExp).name+ " already exist on object ", (object.properties.get(y) as BoolExp)  ,MetaGameLanguagePackage.Literals.BOOL_EXP__BOOL_EXP);
					error("Property " + ( object.properties.get(y) as BoolExp).name+ " already exist on object ", (object.properties.get(y) as BoolExp)  ,MetaGameLanguagePackage.eINSTANCE.boolExp_Bool_exp);
				}else{
					propertyList.add(object.properties.get(y).name);
				}
				
			}else if (object.properties.get(y) instanceof NumberExp){
				if(propertyList.contains(object.properties.get(y).name)){
					error("Property " + (object.properties.get(y) as NumberExp).name + " already exist on object ", (object.properties.get(y) as NumberExp) ,MetaGameLanguagePackage.eINSTANCE.numberExp_Math_exp);
					error("Property " + (object.properties.get(y) as NumberExp).name + " already exist on object ",(object.properties.get(y) as NumberExp) ,MetaGameLanguagePackage.Literals.NUMBER_EXP__MATH_EXP);
				
				}else{
					propertyList.add(object.properties.get(y).name);
				}				
				
			}
		}	
	}
	def dispatch void validateProperty(Location location){
		var List<String> propertyList = new ArrayList();
		for(var y = 0; y < location.properties.length; y++){// Start for # 1		 
			if( location.properties.get(y) instanceof BoolExp){
				if(propertyList.contains(location.properties.get(y).name)){
					error("Property "+(location.properties.get(y) as BoolExp).name+"  already exist on location ", (location.properties.get(y) as BoolExp) ,MetaGameLanguagePackage.Literals.BOOL_EXP__BOOL_EXP);
					error("Property " + ( location.properties.get(y) as BoolExp).name+ " already exist on location ", (location.properties.get(y) as BoolExp)  ,MetaGameLanguagePackage.eINSTANCE.boolExp_Bool_exp);
				
				}else{
					propertyList.add(location.properties.get(y).name);
				}
				
			}else if (location.properties.get(y) instanceof NumberExp){
				if(propertyList.contains(location.properties.get(y).name)){
					error("Property " + (location.properties.get(y) as NumberExp).name + " already exist on location ", (location.properties.get(y) as NumberExp) ,MetaGameLanguagePackage.eINSTANCE.numberExp_Math_exp);
					error("Property " + (location.properties.get(y) as NumberExp).name + " already exist on location ",(location.properties.get(y) as NumberExp) ,MetaGameLanguagePackage.Literals.NUMBER_EXP__MATH_EXP);
		
				
				}else{
					propertyList.add(location.properties.get(y).name);
				}				
				
			}
		}
	}
	
	
	/*
	 * E.g.: Object Agent1 (0,0) Agent1(1,0)   
			    truth value isAgent = true    
			  	number path = 0
  	* 
  	* 	Object names should be unique
  	* 
	*/
	@Check 
	def checkConflictObjectNames(Game game){
		var List<String> seenObjectList = new ArrayList();
		for(var y = 0; y < game.getDeclarations.length; y++){// Start for # 1 
			if (game.getDeclarations.get(y) instanceof Object){
				var object = (game.getDeclarations.get(y) as Object)
				for(var o = 0; o < object.declarations.length; o++){// Start for # 2 
					var objectDeclaration = object.declarations.get(o)
					if (seenObjectList.contains(objectDeclaration.name)){
						error("Object name is a duplicate " + objectDeclaration.name, objectDeclaration ,MetaGameLanguagePackage.eINSTANCE.objectDeclaration_Coordinates);
						error("Object " + objectDeclaration.name+ " is a duplicate ", objectDeclaration ,MetaGameLanguagePackage.Literals.OBJECT_DECLARATION__NAME);
					}
					else{
						seenObjectList.add(objectDeclaration.name)
					}
				} // End for # 2
			}
		}// End for # 1  
	}
	
	/*
	* System.out.println(localVariable.var_local);	// Agent1			
	* System.out.println(localVariable.var_prop.name); // path
	* variable.var_prop.name // test
	* 
	* Loop through each entry, foreach entry (test,test2) check if has dependency to test
	* If yes -> circular dependency
	* 
	* Global properties:
	* test [test2, test3] 
	* test2 []
	* test3 [test]
	* 
	* Local properties 
	*
	*/
	
		
    private Map<String, List<Expression>> graph =  new HashMap()
      
	 @Check
	def checkCircularReferencesOnFields(Game game){		
	
		// Create graph of of all game field properties
		for(var y = 0; y < game.fields.length; y++){		
			var parentName = ""			
			switch game.fields.get(y) {
				BoolExp: parentName = game.fields.get(y).name
				NumberExp:  parentName = game.fields.get(y).name
				default: throw new Error("Invalid expression")
			}			
			
			if(game.fields.get(y) instanceof BoolExp){
				parentName = (game.fields.get(y) as BoolExp).name				
			}else{
				parentName = (game.fields.get(y) as NumberExp).name				
			}		
			addNode(parentName)
			
			// Get property variables e.g test2, test3, test
			/**
			 * Game Validate    
				number test = test2 + test3  
				number test2 = 1
				number test3 = test
			 * 
			 */
			var vars = game.fields.get(y).getVariables			
			
			// add edge between parent properties
			for(var i = 0; i < vars.length; i++){// Start for # 2 
				addEdge(parentName, vars.get(i))
			}			
		}
		
		
		// Add object and location properties to graph
		for(Declaration declaration: game.declarations){// Start for # 1 		
			if(declaration instanceof Object){ // Validate Objects properties
				var object =declaration as Object				
				for(Property property: object.properties){// Start for # 2	
					var vars = property.getVariables
					
					var propertyName = ""
					if(property instanceof BoolExp){
						propertyName = (property as BoolExp).name				
					}else{
						propertyName = (property as NumberExp).name				
					}
					
					// Add all parents
					for(ObjectDeclaration od: object.declarations){
						addNode(od.name+"."+propertyName)
						//System.out.println("Add parent: " + od.name+"."+propertyName); 
					}
					
					// Foreach property, loop through its expression add edge on each expression on all object declarations					
					for(Expression exp : vars){// Start for # 3 
						
						if(exp instanceof LocalVariable){ // local variable e.g. Agent1.score
							var localVariable = exp as LocalVariable					
							for(ObjectDeclaration od: object.declarations){ // Because of the grammar we need to run to all object declarations and add edge between the same expression
								addEdge(od.name+"."+propertyName,  localVariable)
								//System.out.println("(1)Add childs to each parent: " + od.name+"."+propertyName + " Child:" + localVariable.var_local +"."+ localVariable.var_prop.name); 
							}
						} else if(exp instanceof Variable){ // global variable
							var variable = exp as Variable	
							for(ObjectDeclaration od: object.declarations){
								addEdge(od.name+"."+propertyName,  variable)
								//System.out.println("(2)Add childs to each parent: " + od.name+"."+propertyName + " Child:" + variable.var_prop.name); 
							}
						}				
					} // End for # 3	
				}
			}
			else { // Validate Location properties
				var location =declaration as Location	
				for(Property property: location.properties){// Start for # 2	
					var vars = property.getVariables
					
					var propertyName = ""
					if(property instanceof BoolExp){
						propertyName = (property as BoolExp).name				
					}else{
						propertyName = (property as NumberExp).name				
					}
					
					// Add all parents
					for(LocationDeclaration ld: location.declarations){
						addNode(ld.name+"."+propertyName)
						//System.out.println("Add parent: " + ld.name+"."+propertyName); 
					}
					
					// Foreach property, loop through its expression add edge on each expression on all location declarations					
					for(Expression exp : vars){// Start for # 3 
						
						if(exp instanceof LocalVariable){ // local variable e.g. Agent1.score
							var localVariable = exp as LocalVariable					
							for(LocationDeclaration ld: location.declarations){
								addEdge(ld.name+"."+propertyName,  localVariable)
								//System.out.println("(1)Add childs to each parent: " + ld.name+"."+propertyName + " Child:" + localVariable.var_local +"."+ localVariable.var_prop.name); 
							}
						} else if(exp instanceof Variable){ // global variable
							var variable = exp as Variable	
							for(LocationDeclaration ld: location.declarations){
								addEdge(ld.name+"."+propertyName,  variable)
								//System.out.println("(2)Add childs to each parent: " + ld.name+"."+propertyName + " Child:" + variable.var_prop.name); 
							}
						}				
					} // End for # 3	
				}
			} // End if # 
		}// End for # 1
		
		
		var List<String> seen = new ArrayList();	
		// Validate graph
		//System.out.println("Print graph start"); 
		for (Map.Entry<String, List<Expression>> entry : graph.entrySet())
		{
			var children = ""
		    for(Expression child : entry.getValue()){
	    		if(child instanceof LocalVariable){ // local variable e.g. Agent1.score
	    			var localVariable = child as LocalVariable
	    			children += localVariable.var_local +"."+ localVariable.var_prop.name +", "		
	    		}
	    		else
	    		{
	    			var variable = child as Variable	
	    			children += variable.var_prop.name +", "
	    		}
	    		
	    		
	    		
		    	System.out.println("Outer method, Parent: " + entry.key); 
				System.out.println("Outer method, Child: " + children);		    	
		    	//seen.add(entry.key)
		    	validate(child, entry.key, seen)
		    	seen = new ArrayList() // List to be cleared every time a new recursion 
		    	//errorThrownOnThisEpression = new ArrayList();
	    	}
	    	//System.out.println(entry.key +": "+ children);
		}
		//System.out.println("End graph start"); 
	}
	
	// List which is needed to keep track of which elements errors already has been thrown
	// List should avoid to that multiple errors are thrown on same elements
	// Agent1.path : Agent3.path
	// Agent2.path : Agent3.path
	// Agent3.path : Agent2.path
	private List<String> errorThrownOnThisEpression =  new ArrayList()
	def boolean validate(Expression child, String parent, List<String> seen){
		
    	System.out.println("validate method called with parent: " + parent); 
		//System.out.println("Child: " + (child as Variable).var_prop.name);	
			
		var seenString = ""
		for(String se: seen){
			seenString += se + ", " 	
		}
		System.out.println("Seen list contains: " + seenString)
		
		if(child instanceof LocalVariable){ // local variable e.g. Agent1.score
			var childLocalVariable = child as LocalVariable					
			var key = childLocalVariable.var_local +"."+ childLocalVariable.var_prop.name // E.g Agent1.score
			if(graph.containsKey(key)){
				// Get childs dependencies
				var children = graph.get(key); // Agent3.path
				  // Loop over each expression to check if there are name Coalission
				  	
				  				  	
					for(Expression exp : children){ 
		  				if(exp instanceof LocalVariable){ // Local variable on a global variable
							var localVariable = exp as LocalVariable
							var localVariableKey =  localVariable.var_local +"." +localVariable.var_prop.name // Agent2.path
							
							if(seen.contains(localVariableKey)){
								if(!errorThrownOnThisEpression.contains(localVariableKey)){
									System.out.println("1: validation failed " +localVariableKey )
									error("1: Circular reference on property " + parent, localVariable ,MetaGameLanguagePackage.Literals.LOCAL_VARIABLE__VAR_PROP);
									//error("Circular reference on object " + childLocalVariable.var_local, localVariable ,MetaGameLanguagePackage.eINSTANCE.localVariable_Var_local);
									return false
								}
								else{
									errorThrownOnThisEpression.add(localVariableKey)
								}
						
							}else{
								System.out.println("Add to seen list: " + localVariableKey)
								seen.add(localVariableKey)
								if(!validate(exp,key,seen)){
									System.out.println("2: validation failed " +localVariableKey )
									if(!errorThrownOnThisEpression.contains(localVariableKey)){
										//error("2: Circular reference on property " + parent, localVariable ,MetaGameLanguagePackage.Literals.LOCAL_VARIABLE__VAR_PROP);
										//error("Circular reference on object " + childLocalVariable.var_local, localVariable ,MetaGameLanguagePackage.eINSTANCE.localVariable_Var_local);
										return false
									}
									else{
										errorThrownOnThisEpression.add(localVariableKey)
									}
								}
							}
						
						}
						else if(exp instanceof Variable){ // Global variable in "local variable" expression
							var variable = exp as Variable
							
							if(seen.contains(variable.var_prop.name)){
								System.out.println("Circular reference on " + parent); 	
								error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
								return false
							}else{
								System.out.println("seen.add(variable.var_prop.name " + variable.var_prop.name);
								System.out.println("!validate(exp,key,seen) " + (exp as Variable).var_prop.name + " " +key); 
								seen.add(variable.var_prop.name)
								if(!validate(exp,key,seen)){
									error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
								}
							}
							
							
						}
				  }
				  
				  return true
			}	
				
		}
		else{ // global variable
			var childVariable = child as Variable		
			// Validate if check exist as an entry (todo: if not property doesent exist error)
			if(graph.containsKey(childVariable.var_prop.name)){
				// Get childs dependencies
				var children = graph.get(childVariable.var_prop.name);
				
				System.out.println("children.size " + children.size); 	
				
				if(children.size== 0) return true
				
				  // Loop over each expression to check if there are name Coalission
				  for(Expression exp : children){ 
		  				if(exp instanceof LocalVariable){ // Local variable on a global variable e.g. number test = Agent1.score + 1
							var localVariable = exp as LocalVariable
								
						}
						if(exp instanceof Variable){ // Global variable on global variable
							var variable = exp as Variable
							
							if(seen.contains(variable.var_prop.name)){
					     		System.out.println("Circular reference on " + parent); 	
								error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
								return false
							}else{
								System.out.println("variable.var_prop.name " + variable.var_prop.name); 
								seen.add(variable.var_prop.name)
								if(!validate(exp,childVariable.var_prop.name,seen)){
									System.out.println("validation failed on " +childVariable.var_prop.name+ " .... variable.var_prop.name " + variable.var_prop.name); 
									error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
								}
							}						
							
						}
				  }
				  return true
			}
		}
		return true
	}
	
	def void validate(Expression child, String parent){
		if(child instanceof LocalVariable){ // local variable e.g. Agent1.score
			var childLocalVariable = child as LocalVariable					
			var key = childLocalVariable.var_local +"."+ childLocalVariable.var_prop.name // E.g Agent1.score
			if(graph.containsKey(key)){
				// Get childs dependencies
				var children = graph.get(key);
				  // Loop over each expression to check if there are name Coalission
				  for(Expression exp : children){ 
		  				if(exp instanceof LocalVariable){ // Local variable on a global variable
							var localVariable = exp as LocalVariable
							var localVariableKey =  localVariable.var_local +"." +localVariable.var_prop.name
							if( localVariableKey == parent){
								System.out.println("Circular reference on " + parent); 	
								error("Circular reference on property " + parent, localVariable ,MetaGameLanguagePackage.Literals.LOCAL_VARIABLE__VAR_PROP);
								error("Circular reference on object " + childLocalVariable.var_local, localVariable ,MetaGameLanguagePackage.eINSTANCE.localVariable_Var_local);
							}			
						}
						if(exp instanceof Variable){ // Global variable in "local variable" expression
							var variable = exp as Variable
							if(variable.var_prop.name == parent){
								System.out.println("Circular reference on " + parent); 	
								error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
							}		
						}
				  }
			}	
				
		}
		else{ // global variable
			var childVariable = child as Variable		
			// Validate if check exist as an entry (todo: if not property doesent exist error)
			if(graph.containsKey(childVariable.var_prop.name)){
				// Get childs dependencies
				var children = graph.get(childVariable.var_prop.name);
				  // Loop over each expression to check if there are name Coalission
				  for(Expression exp : children){ 
		  				if(exp instanceof LocalVariable){ // Local variable on a global variable e.g. number test = Agent1.score + 1
							var localVariable = exp as LocalVariable
								
						}
						if(exp instanceof Variable){ // Global variable on global variable
							var variable = exp as Variable
							if(variable.var_prop.name == parent){
								System.out.println("Circular reference on " + parent); 	
								error("Circular reference on " + parent, variable ,MetaGameLanguagePackage.Literals.VARIABLE__VAR_PROP);
							}		
						}
				  }
			}
		}	
		
	} 
	
    def void addNode(String name) {
       
        var List<Expression> list = new LinkedList<Expression>();
        graph.put(name, list);
    }

    def void addEdge(String parent, Expression child) throws Exception {
        var List<Expression> list;
        if (!graph.containsKey(parent)) {
        	//System.out.println("new list to node: " + parent);
            list = new LinkedList<Expression>();
        } else {
            list = graph.get(parent);
        }
        list.add(child);
        graph.put(parent, list);
        
        
        
        
        
    }
	
	
	
	//@Check
	def checkConflictProperty(Property property){
		var List<String> objectList = new ArrayList();
		var List<String> propertyList = new ArrayList();
		var List<String> errorList = new ArrayList();
		
		
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println("Start");
			
		System.out.println(property.eContainer.eClass.instanceClass);
		System.out.println(property);
		
		// Check if the current property parent is an object
		if(property.eContainer.eClass.instanceClass.equals(com.metagamedsl.individual.metaGameLanguage.Object)){
			var currentObject = property.eContainer as Object;
			System.out.println("Innerloop start");
			for(var i = 0; i <currentObject.getDeclarations.length; i++){				
				// Save the property's object name into a list
				//System.out.println("Reference object name: " + currentObject.getDeclarations.get(i).name);
				objectList.add(currentObject.getDeclarations.get(i).name);				
			}
			System.out.println("Innerloop end");	
			
			// Loop through all actual objects which properties need to be validated
			for(var y = 0; y < objectList.length; y++){ // start for # 0
				// Loop through properties of the property's scope	
				for(var i = 0; i < property.eContainer.eContents.length; i++){ // start for # 1						
						
						if (property.eContainer.eContents.get(i) instanceof BoolExp || property.eContainer.eContents.get(i) instanceof NumberExp){
							
							// Check if the property parent is object
							if(property.eContainer.eContents.get(i).eContainer.eClass.instanceClass.equals(com.metagamedsl.individual.metaGameLanguage.Object)){
								var candidateObject = property.eContainer.eContents.get(i).eContainer as Object;
								
								for(var j = 0; j <candidateObject.getDeclarations.length; j++){// start for # 2										
																		
									// Check that this is the actual object property which we want to validate
									if(objectList.get(y).equals(candidateObject.getDeclarations.get(j).name)){
										
										System.out.println("We found a match: " + candidateObject.getDeclarations.get(j).name);
										
										
										// Get property "name" based on if it a number or a bool									
										var propertyName = "";
										if (property.eContainer.eContents.get(i) instanceof BoolExp){
											var propertyType = property.eContainer.eContents.get(i) as BoolExp;
											propertyName = propertyType.name;
										} 
										else if (property.eContainer.eContents.get(i) instanceof NumberExp){
											var propertyType = property.eContainer.eContents.get(i) as NumberExp;
											propertyName = propertyType.name;
										} 
										
										System.out.println("Property of interest name: "+ propertyName);
										
										// Only throw error if the property exists
										if(propertyList.contains(candidateObject.getDeclarations.get(j).name+ "."+propertyName)){
											System.out.println("*********************************************************************************");
											System.out.println("Property exists : "+ candidateObject.getDeclarations.get(j).name+ "."+propertyName);
											System.out.println("*********************************************************************************");
																									
											
											if(!errorList.contains(candidateObject.getDeclarations.get(j).name+ "."+propertyName )){
												errorList.add(candidateObject.getDeclarations.get(j).name+ "."+propertyName);
												try 
												{
												   	if (property.eContainer.eContents.get(i) instanceof BoolExp){
														error("Property already exist on object '"+candidateObject.getDeclarations.get(j).name+ "."+propertyName +"'",MetaGameLanguagePackage.eINSTANCE.getBoolExp_Bool_exp);
													} 
													else if (property.eContainer.eContents.get(i) instanceof NumberExp){												   		
														error("Property already exist  on object '"+candidateObject.getDeclarations.get(j).name+ "."+propertyName +"'",property,MetaGameLanguagePackage.eINSTANCE.getNumberExp_Math_exp);
													    //error("Property already exist  on object '"+candidateObject.getDeclarations.get(j).name+ "."+propertyName +"'",property,MetaGameLanguagePackage.Literals.NUMBER_EXP__MATH_EXP);
													  
													}
											  	} 
											  	catch (IllegalArgumentException e) {
												   //throw new IllegalArgumentException(e);
											  	}											  	
											}
																		
										}else{
											propertyList.add(candidateObject.getDeclarations.get(j).name+ "."+propertyName);
											System.out.println("Property added: "+ candidateObject.getDeclarations.get(j).name+ "."+propertyName);
										}
										
									} // end if			
								} // end for # 2
							} // end if
						} 
					} // end if
					
				} // end for # 1
			} // end for # 0
			

		System.out.println("End");
		System.out.println();
		System.out.println();
		System.out.println();
		
	}
	
	@Check
	def checkLegalAgentPosition(Object object){
		
		for(var i = 0; i < object.getDeclarations.length; i++){
			var x = object.getDeclarations.get(i).coordinates.x;
			var y = object.getDeclarations.get(i).coordinates.y;
			
			//System.out.println("****************************************************");
			//System.out.println("Object name: " + object.getDeclarations.get(i).name);
			//System.out.println("x: " + x);
			//System.out.println("y: " + y);
			//System.out.println("****************************************************");
			
			if(x > 4 ||y>4){
				error("Coordinates is out of scope '"+object.getDeclarations.get(i).name +"'",MetaGameLanguagePackage.eINSTANCE.object_Declarations);
			}
		}
	}
	
}
