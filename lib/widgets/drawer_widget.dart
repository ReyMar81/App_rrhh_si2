import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/auth_service.dart';
import 'package:mobile_app/routes/app_routes.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String nombreUsuario = '';
  String cargoUsuario = '';
  bool cargando = true;
  bool expandido = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final nombre = await AuthService.getUserName();
    final rol = await AuthService.getUserRol();
    setState(() {
      nombreUsuario = nombre ?? 'Empleado';
      cargoUsuario = rol ?? '';
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // CABECERA con usuario, rol y botón desplegable
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            color: primaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nombreUsuario,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            offset: const Offset(0, 40),
                            color: Colors.white,
                            elevation: 4,
                            onSelected: (value) {
                              if (value == 'perfil') {
                                Navigator.pushNamed(context, AppRoutes.perfil);
                              } else if (value == 'cambiar') {
                                Navigator.pushNamed(
                                    context, AppRoutes.cambiarPassword);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'perfil',
                                height: 36,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Perfil',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'cambiar',
                                height: 36,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Cambiar contraseña',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        cargoUsuario,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CONTENIDO PRINCIPAL DEL DRAWER
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Gestión',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sectionLabelColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Documentos'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.documentos);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_tree),
                  title: const Text('Departamentos'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.departamentos);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Empleados'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.empleadosPorDepto);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Tomar Asistencia'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.tomarAsistencia);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fact_check),
                  title: const Text('Asistencias del Día'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.asistenciasHoy);
                  },
                ),
              ],
            ),
          ),

          // BOTÓN DE CERRAR SESIÓN
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.exit_to_app),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: dangerColor,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await AuthService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
