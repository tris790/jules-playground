#ifndef BRB_NETWORKING_H
#define BRB_NETWORKING_H

// Placeholder for networking system (ENet / custom UDP, rollback)
// E.g., connecting to peers, sending/receiving game state

int brb_network_initialize();
int brb_network_connect(const char* host, int port);
void brb_network_send_packet(/* some data */);
void brb_network_receive_packets(/* callback or buffer */);
void brb_network_shutdown();

#endif // BRB_NETWORKING_H
