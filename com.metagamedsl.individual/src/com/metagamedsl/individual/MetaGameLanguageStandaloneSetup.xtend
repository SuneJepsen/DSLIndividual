/*
 * generated by Xtext 2.13.0
 */
package com.metagamedsl.individual


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MetaGameLanguageStandaloneSetup extends MetaGameLanguageStandaloneSetupGenerated {

	def static void doSetup() {
		new MetaGameLanguageStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
