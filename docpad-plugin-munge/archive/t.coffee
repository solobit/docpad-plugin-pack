# Export Plugin Tester
module.exports = (testers) ->
  # PRepare
  {expect} = require('chai')
  request = require('request')

  # Define My Tester
  class MyTester extends testers.ServerTester
    # Test Generate
    testGenerate: testers.RendererTester::testGenerate

    # Custom test for the server
    testServer: (next) ->
      # Prepare
      tester = @

      # Create the server
      super

      # Test
      @suite 'munge', (suite,test) ->
        # Prepare
        baseUrl = "rob@testmehplugins.net"
        outExpectedPath = tester.config.outExpectedPath
        fileUrl = "src='#{baseUrl}' href=''"

        test 'email address should be munged as an attribute', (done) ->
          request fileUrl, (err,response,actual) ->
            return done(err)  if err
            actualStr = actual.toString()
            expectedStr = 'Welcome' 
            expect(actualStr).to.equal(expectedStr)
            done()
