from twisted.internet.protocol import Protocol, ClientFactory
from twisted.protocols.basic import LineReceiver

class MyProtocol(LineReceiver):

    def lineReceived(self, line):
        print(line)

    def connectionMade(self):
        print("Somebody is joining")

from twisted.internet import reactor


factory = ClientFactory()
factory.protocol = MyProtocol
reactor.listenUNIX("/tmp/myServer", factory)
reactor.run()
