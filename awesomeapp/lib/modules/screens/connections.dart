import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/font_constants.dart';
import '../components/connection_tile.dart';
import '../services/connections_provider.dart';
import '../../core/shared/custum_appbar.dart';

class ConnectionsScreen extends StatelessWidget {
  static const id = 'connections';

  @override
  Widget build(BuildContext context) {
    return _ConnectionsScreen();
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
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Connections',
            style: bodyMediumTextStyle.copyWith(
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if(provider.errorMessage != null){
            return Center(
              child: Text(
                provider.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            );
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
