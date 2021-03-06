package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class JavaCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("invTagElement", "context TagElement inv invTagElement: self.fragments->select(te|te.oclIsTypeOf(TextElement))->forAll(te1|TextElement.allInstances()->exists(te2|te2.text = te1.oclAsType(TextElement).text))");
		consMap.put("invTextElement", "context TextElement inv invTextElement: TagElement.allInstances()->exists(te1|te1.fragments->select(te2|te2.oclIsTypeOf(TextElement))->exists(te3| te3.oclAsType(TextElement).text = self.text))");
		consMap.put("invSingleVariableAccess", "context SingleVariableAccess inv invSingleVariableAccess: VariableDeclaration.allInstances()->exists(vd | vd = self.variable)");
		consMap.put("invModifier", "context Modifier inv invModifier: " +
				" (self.bodyDeclaration <> null implies BodyDeclaration.allInstances()->exists(bd | bd = self.bodyDeclaration)) and " +
				" (self.singleVariableDeclaration <> null implies SingleVariableDeclaration.allInstances()->exists(svd | svd = self.singleVariableDeclaration)) and " +
				" (self.variableDeclarationStatement <> null implies VariableDeclarationStatement.allInstances()->exists(vds | vds = self.variableDeclarationStatement)) and " +
				" (self.variableDeclarationExpression <> null implies VariableDeclarationExpression.allInstances()->exists(vde | vde = self.variableDeclarationExpression))");
		consMap.put("invTypeAccess", "context TypeAccess inv invTypeAccess: Type.allInstances()->exists(t|self.type.name = t.name)");
		consMap.put("invMethodInvocation", "context MethodInvocation inv invMethodInvocation: MethodDeclaration.allInstances()->exists(md|md = self.method) and " +
				" self.arguments->forAll(arg|arg.oclIsTypeOf(SingleVariableAccess) implies SingleVariableAccess.allInstances()->exists(sva | sva = arg))");
		consMap.put("invExpressionStatment", "context ExpressionStatement inv invExpressionStatment: Expression.allInstances()->exists(e|e = self.expression)");
		
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : JavaCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
