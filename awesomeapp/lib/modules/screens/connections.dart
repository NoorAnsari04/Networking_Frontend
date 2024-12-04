import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/font_constants.dart';
import '../componenets/connection_tile.dart';
import '../services/connections_provider.dart';

class ConnectionsScreen extends StatelessWidget {
  static const id = 'connections';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectionsProvider(),
      child: _ConnectionsScreen(),
    );
  }
}

class _ConnectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConnectionsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadConnections();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Connections',
            style: bodyMediumTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.connections.isEmpty) {
            return Center(
              child: Text(
                'No connections available.',
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.connections.length,
            itemBuilder: (context, index) {
              final user = provider.connections[index];
              return ConnectionTile(
                user: user,
              );
            },
          );
        },
      ),
    );
  }
}
