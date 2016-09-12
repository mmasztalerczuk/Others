from twisted.internet.protocol import Protocol, ClientFactory
from twisted.protocols.basic import LineReceiver

class MyProtocol(LineReceiver):
    
    def connectionMade(self):
        self.sendLine("Elo")
        print("Connection made")


from twisted.internet import reactor


factory = ClientFactory()
factory.protocol = MyProtocol
reactor.connectUNIX("/tmp/myServer", factory)
reactor.run()
