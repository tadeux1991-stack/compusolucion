import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_background/animated_background.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Offset _mousePos = Offset.zero;
  
  final _servicesKey = GlobalKey();
  final _portfolioKey = GlobalKey();
  final _contactKey = GlobalKey();

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/529992204040?text=Hola%20Compusolución,%20necesito%20información%20sobre%20un%20servicio.');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final bool isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final bool useDrawer = isMobile || isTablet || MediaQuery.of(context).size.width < 1000;

    return MouseRegion(
      cursor: isMobile ? SystemMouseCursors.basic : SystemMouseCursors.none,
      onHover: (event) {
        setState(() {
          _mousePos = event.position;
        });
      },
      child: Stack(
        children: [
          DefaultTextStyle(
            style: const TextStyle(decoration: TextDecoration.none),
            child: Scaffold(
              key: _scaffoldKey,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 30),
                    const SizedBox(width: 10),
                    if (!isMobile)
                      Text(
                        'COMPUSOLUCIÓN',
                        style: GoogleFonts.orbitron(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                  ],
                ),
                actions: useDrawer 
                  ? [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                      ),
                      const SizedBox(width: 10),
                    ]
                  : [
                      _navItem('Servicios', () => _scrollTo(_servicesKey)),
                      _navItem('Portafolio', () => _scrollTo(_portfolioKey)),
                      _navItem('Contacto', () => _scrollTo(_contactKey)),
                      const SizedBox(width: 20),
                    ],
              ),
              endDrawer: useDrawer ? _buildDrawer() : null,
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildHeroSection(context),
                    _buildServicesSection(context),
                    _buildPortfolioSection(context),
                    _buildContactSection(context),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
          if (!isMobile) ...[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              left: _mousePos.dx - 20,
              top: _mousePos.dy - 20,
              child: IgnorePointer(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.neonPurple.withOpacity(0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: AppTheme.neonPurple.withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: _mousePos.dx - 4,
              top: _mousePos.dy - 4,
              child: IgnorePointer(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.neonCyan,
                    boxShadow: [
                      BoxShadow(color: AppTheme.neonCyan, blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.darkBg.withOpacity(0.95),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Center(child: Image.asset('assets/images/logo.png', height: 60)),
          ),
          _drawerItem('Servicios', Icons.settings_suggest, () {
            Navigator.pop(context);
            _scrollTo(_servicesKey);
          }),
          _drawerItem('Portafolio', Icons.grid_view_rounded, () {
            Navigator.pop(context);
            _scrollTo(_portfolioKey);
          }),
          _drawerItem('Contacto', Icons.contact_support, () {
            Navigator.pop(context);
            _scrollTo(_contactKey);
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.neonCyan),
      title: Text(title, style: const TextStyle(color: Colors.white, decoration: TextDecoration.none)),
      onTap: onTap,
    );
  }

  Widget _navItem(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 1000;

    return Container(
      height: size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.5, -0.3),
          radius: 1.2,
          colors: [Color(0xFF1A1A2E), AppTheme.darkBg],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: const ParticleOptions(
                baseColor: AppTheme.neonCyan,
                spawnMaxRadius: 2.0,
                spawnMinRadius: 1.0,
                particleCount: 60,
                spawnOpacity: 0.0,
                minOpacity: 0.1,
                maxOpacity: 0.4,
              ),
            ),
            vsync: this,
            child: const SizedBox.expand(),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.neonPurple.withAlpha(50), blurRadius: 100, spreadRadius: 50),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: isSmall ? 20 : 100),
              child: Flex(
                direction: isSmall ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isSmall ? 600 : 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INNOVACIÓN EN TUS MANOS',
                          textAlign: isSmall ? TextAlign.center : TextAlign.start,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: isSmall ? 36 : 60,
                            height: 1.1,
                            decoration: TextDecoration.none,
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                        const SizedBox(height: 20),
                        Text(
                          'Expertos en reparación de hardware y desarrollo de software a medida.',
                          textAlign: isSmall ? TextAlign.center : TextAlign.start,
                          style: TextStyle(
                            fontSize: isSmall ? 18 : 22,
                            color: Colors.white.withAlpha(180),
                            decoration: TextDecoration.none,
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _scrollTo(_servicesKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.neonCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('EMPEZAR AHORA', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                        ).animate().scale(delay: 800.ms),
                      ],
                    ),
                  ),
                  if (!isSmall) const SizedBox(width: 50),
                  Flexible(
                    child: Container(
                      width: isSmall ? 280 : 450,
                      height: isSmall ? 200 : 320,
                      margin: EdgeInsets.only(top: isSmall ? 40 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.elliptical(300, 200)),
                        boxShadow: [
                          BoxShadow(color: AppTheme.neonCyan.withOpacity(0.2), blurRadius: 50, spreadRadius: 10),
                        ],
                        border: Border.all(color: AppTheme.neonCyan.withOpacity(0.3), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.elliptical(300, 200)),
                        child: Image.asset('assets/images/mascota.png', fit: BoxFit.contain),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 3000.ms)
                      .moveY(begin: -15, end: 15, duration: 2500.ms, curve: Curves.easeInOutSine)
                      .then().moveY(begin: 15, end: -15, duration: 2500.ms, curve: Curves.easeInOutSine),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      key: _servicesKey,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isSmall ? 20 : 50),
      child: Column(
        children: [
          Text('NUESTROS SERVICIOS', 
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: isSmall ? 24 : 32, decoration: TextDecoration.none)),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _serviceCard(
                'Reparación Pro', 
                'Soporte especializado para laptops y PCs.', 
                Icons.computer,
                () => _showDetailDialog(
                  context, 
                  'CIRUGÍA TÉCNICA PRO', 
                  AppTheme.neonCyan, 
                  [
                    _detailItem(Icons.speed, 'OPTIMIZACIÓN EXTREMA', 'Instalación de SSD y aumento de RAM. Revivimos tu PC vieja en 24h.'),
                    _detailItem(Icons.thermostat, 'MANTENIMIENTO TÉRMICO', 'Limpieza profunda y cambio de pasta térmica de alto rendimiento.'),
                    _detailItem(Icons.screenshot, 'PANTALLAS Y HARDWARE', 'Cambio de displays rotos, teclados, bisagras y reparación de tarjetas madre.'),
                    _detailItem(Icons.storage, 'RESCATE DE DATOS', 'Recuperación de archivos en discos dañados y diagnóstico preventivo.'),
                  ],
                  '💡 TIP COMPUSOLUCIÓN: Enviamos fotos y videos de todo el proceso por WhatsApp.'
                ),
              ),
              _serviceCard(
                'App Dev', 
                'Desarrollo de apps móviles y web a medida.', 
                Icons.app_registration,
                () => _showDetailDialog(
                  context, 
                  'FÁBRICA DE APPS', 
                  AppTheme.neonPurple, 
                  [
                    _detailItem(Icons.phone_android, 'MOBILE MULTIPLATAFORMA', 'Creamos apps para Android e iOS usando Flutter. Una sola base de código.'),
                    _detailItem(Icons.web, 'WEB APPS DINÁMICAS', 'Plataformas web rápidas, seguras y escalables para tu negocio.'),
                    _detailItem(Icons.auto_awesome, 'AUTOMATIZACIÓN', 'Sistemas de inventarios, puntos de venta y administración a medida.'),
                    _detailItem(Icons.palette, 'DISEÑO UX/UI PRESTIGE', 'Interfaces hermosas e intuitivas que tus clientes amarán.'),
                  ],
                  '🚀 VISIÓN COMPUSOLUCIÓN: Construimos la herramienta que hará crecer tu negocio.'
                ),
              ),
              _serviceCard(
                'Networking', 
                'Instalación y mantenimiento de redes.', 
                Icons.wifi,
                () => _showDetailDialog(
                  context, 
                  'INFRAESTRUCTURA RED', 
                  Colors.orangeAccent, 
                  [
                    _detailItem(Icons.router, 'WIFI 6 & MESH SYSTEMS', 'Eliminamos las zonas muertas. Internet fluido con tecnología Mesh.'),
                    _detailItem(Icons.security, 'SEGURIDAD & FIREWALL', 'Protegemos tu red contra intrusos y configuramos controles parentales.'),
                    _detailItem(Icons.settings_ethernet, 'CABLEADO ESTRUCTURADO', 'Instalación de puntos de red Cat 6e para Gaming y Streaming.'),
                    _detailItem(Icons.cloud_sync, 'ADMINISTRACIÓN REMOTA', 'Monitoreo y soporte técnico a distancia para que nunca dejes de funcionar.'),
                  ],
                  '📡 CONEXIÓN COMPUSOLUCIÓN: Optimizamos tu experiencia para que la velocidad sea tu estándar.'
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String title, Color color, List<Widget> items, String tip) {
    final bool isSmall = MediaQuery.of(context).size.width < 600;
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: DefaultTextStyle(
              style: const TextStyle(decoration: TextDecoration.none),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * (isSmall ? 0.9 : 0.6),
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isSmall ? 20 : 35),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title, 
                                        style: GoogleFonts.orbitron(
                                          fontSize: isSmall ? 18 : 22, 
                                          color: color, 
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        )
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('ESPECIFICACIONES Y DETALLES', style: GoogleFonts.orbitron(fontSize: 10, color: color.withOpacity(0.7), letterSpacing: 1.5)),
                                const SizedBox(height: 25),
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...items,
                                        const SizedBox(height: 30),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: color.withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            tip,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 13, decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _detailItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.neonCyan, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.none)),
                const SizedBox(height: 5),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13, decoration: TextDecoration.none)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, String desc, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: GlassCard(
        width: 280,
        height: 320,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: AppTheme.neonCyan),
              const SizedBox(height: 20),
              Text(title, style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              const SizedBox(height: 15),
              Text(desc, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14, decoration: TextDecoration.none)),
              const SizedBox(height: 20),
              Text('VER DETALLES →', style: TextStyle(color: AppTheme.neonPurple, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale();
  }

  Widget _buildPortfolioSection(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 800;
    
    return Container(
      key: _portfolioKey,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isSmall ? 20 : 50),
      child: Column(
        children: [
          Text(
            'CASOS DE ÉXITO', 
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              decoration: TextDecoration.none,
              color: AppTheme.neonPurple,
            )
          ),
          const SizedBox(height: 20),
          const Text(
            'Innovación aplicada en cada proyecto de hardware y software.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, decoration: TextDecoration.none),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _portfolioCard(
                'ERP Comercio Local', 
                'Admin Web', 
                'Gestión total de ventas, stock y facturación en la nube.',
                '#SaaS',
                Icons.analytics,
                () => _showDetailDialog(
                  context, 
                  'SISTEMA ERP PRO', 
                  AppTheme.neonCyan, 
                  [
                    _detailItem(Icons.storage, 'BASE DE DATOS SQL', 'Arquitectura escalable para manejar miles de productos y transacciones diarias.'),
                    _detailItem(Icons.cloud_upload, 'SINCRONIZACIÓN', 'Vende en tienda física y consulta reportes en tiempo real desde cualquier dispositivo.'),
                    _detailItem(Icons.security, 'ENCRIPTACIÓN SSL', 'Seguridad total en tus datos bancarios y de clientes con backups diarios.'),
                    _detailItem(Icons.speed, 'OPTIMIZACIÓN', 'Interfaz ultra rápida diseñada para agilizar el proceso de cobro en caja.'),
                  ],
                  '💻 CASO DE ÉXITO: Implementado en Conkal, logrando control total de inventarios.'
                ),
              ),
              _portfolioCard(
                'Workstation 4K', 
                'Hardware', 
                'Restauración y upgrade extremo para edición profesional.',
                '#Performance',
                Icons.video_settings,
                () => _showDetailDialog(
                  context, 
                  'WORKSTATION 4K REVIVE', 
                  Colors.amberAccent, 
                  [
                    _detailItem(Icons.bolt, 'UPGRADE NVMe', 'Cambio a disco de estado sólido de alta gama para lectura de 7000MB/s.'),
                    _detailItem(Icons.hvac, 'RE-PASTE PRO', 'Limpieza interna completa y aplicación de pasta térmica de metal líquido.'),
                    _detailItem(Icons.memory, 'EXPANCIÓN RAM', 'Aumento a 64GB de RAM para edición de video 4K sin interrupciones.'),
                    _detailItem(Icons.verified, 'CERTIFICACIÓN', 'Pruebas de rendimiento extremo garantizando 0 fallos bajo carga pesada.'),
                  ],
                  '🛠️ RESULTADO: El equipo recuperó su potencia original para flujos de trabajo profesionales.'
                ),
              ),
              _portfolioCard(
                'Smart Home Red', 
                'Networking', 
                'Estructura de red WiFi 6 para residencias inteligentes.',
                '#WiFi6',
                Icons.home_work,
                () => _showDetailDialog(
                  context, 
                  'RED MESH RESIDENCIAL', 
                  Colors.orangeAccent, 
                  [
                    _detailItem(Icons.router, 'MESH TRI-BANDA', 'Red inteligente con roaming automático para cobertura total en interiores y exteriores.'),
                    _detailItem(Icons.lan, 'BACKHAUL GIGABIT', 'Cableado estructurado Cat 6e para asegurar latencia mínima en consolas y TVs.'),
                    _detailItem(Icons.security, 'VLAN ISOLATION', 'Separación de red para invitados y dispositivos IoT para máxima seguridad.'),
                    _detailItem(Icons.signal_wifi_4_bar, 'OPTIMIZACIÓN', 'Ajuste de canales para evitar interferencias en zonas de alta densidad.'),
                  ],
                  '📡 CONECTIVIDAD: Solución de alta fidelidad para home-office y domótica avanzada.'
                ),
              ),
              _portfolioCard(
                'Estética SaaS', 
                'App Móvil', 
                'Plataforma de citas y pagos para salones de belleza.',
                '#Flutter',
                Icons.auto_awesome,
                () => _showDetailDialog(
                  context, 
                  'BEAUTY PLATFORM', 
                  AppTheme.neonPurple, 
                  [
                    _detailItem(Icons.calendar_month, 'AGENDA 24/7', 'Tus clientes reservan servicios desde la app sin intervención manual.'),
                    _detailItem(Icons.notifications_active, 'PUSH ALERTS', 'Recordatorios automáticos que reducen las faltas de clientes en un 30%.'),
                    _detailItem(Icons.payments, 'WALLET INTEGRATION', 'Pasarela de pagos segura para cobrar anticipos y evitar cancelaciones.'),
                    _detailItem(Icons.palette, 'UX/UI MODERNA', 'Diseño elegante que refleja la exclusividad de tu negocio de belleza.'),
                  ],
                  '🚀 VISIÓN: La herramienta definitiva para digitalizar negocios de servicios locales.'
                ),
              ),
              _portfolioCard(
                'Blindaje PyME', 
                'Seguridad', 
                'Auditoría y protección contra ciberataques.',
                '#CyberSec',
                Icons.admin_panel_settings,
                () => _showDetailDialog(
                  context, 
                  'BLINDAJE DIGITAL', 
                  Colors.lightGreenAccent, 
                  [
                    _detailItem(Icons.lock, 'FIREWALL ACTIVADO', 'Configuración de hardware de seguridad para bloquear tráfico malicioso.'),
                    _detailItem(Icons.password, '2FA IMPLEMENTACIÓN', 'Protección de accesos mediante autenticación de dos factores en toda la red.'),
                    _detailItem(Icons.backup, 'DRP PLAN', 'Protocolo de recuperación ante desastres para asegurar la continuidad del negocio.'),
                    _detailItem(Icons.visibility, 'MONITOREO', 'Detección de intrusos en tiempo real con alertas al administrador.'),
                  ],
                  '🛡️ SEGURIDAD: Protección proactiva para la tranquilidad de tu empresa.'
                ),
              ),
              _portfolioCard(
                'Gaming Master', 
                'Ensamble', 
                'Computadoras de alto desempeño con estética personalizada.',
                '#Gaming',
                Icons.sports_esports,
                () => _showDetailDialog(
                  context, 
                  'ULTIMATE GAMING BUILD', 
                  Colors.redAccent, 
                  [
                    _detailItem(Icons.architecture, 'CABLE MANAGEMENT', 'Flujo de aire optimizado y estética visual impecable.'),
                    _detailItem(Icons.color_lens, 'ARGB SYNC', 'Iluminación personalizada sincronizada con el rendimiento del sistema.'),
                    _detailItem(Icons.shutter_speed, 'OC TUNING', 'Overclock estable para maximizar cada FPS en tus juegos favoritos.'),
                    _detailItem(Icons.water_drop, 'LIQUID COOLING', 'Instalación de sistemas de enfriamiento líquido de alto rendimiento.'),
                  ],
                  '🎮 PASIÓN: Construimos el hardware que te llevará a la victoria.'
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _portfolioCard(String title, String category, String desc, String tag, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Toda la tarjeta es clickable ahora
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        width: 280,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: AppTheme.neonCyan, size: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.neonPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.neonPurple.withOpacity(0.5)),
                    ),
                    child: Text(
                      tag, 
                      style: const TextStyle(color: AppTheme.neonPurple, fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.none)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                category.toUpperCase(), 
                style: const TextStyle(color: AppTheme.neonCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, decoration: TextDecoration.none)
              ),
              const SizedBox(height: 10),
              Text(
                title, 
                style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.none)
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Text(
                  desc, 
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5, decoration: TextDecoration.none),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'DETALLES →', 
                style: TextStyle(color: AppTheme.neonCyan.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.none)
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildContactSection(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 900;
    return Container(
      key: _contactKey,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isSmall ? 20 : 50),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.darkBg, Colors.black])),
      child: Column(
        children: [
          Text('CONTACTO DIRECTO', style: Theme.of(context).textTheme.headlineMedium?.copyWith(decoration: TextDecoration.none)),
          const SizedBox(height: 60),
          Flex(
            direction: isSmall ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isSmall ? double.infinity : 400),
                child: GlassCard(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        _contactInfoItem(Icons.location_on, 'UBICACIÓN', 'Conkal, Yucatán'),
                        _contactInfoItem(Icons.email, 'EMAIL', 'contactocompusolucion@gmail.com'),
                        _contactInfoItem(Icons.phone_android, 'WHATSAPP', '999 220 4040'),
                        _contactInfoItem(Icons.access_time_filled, 'HORARIO', 'Lun-Vie: 8-7'),
                      ],
                    ),
                  ),
                ),
              ),
              if (isSmall) const SizedBox(height: 40),
              if (!isSmall) const SizedBox(width: 50),
              Flexible(
                child: Column(
                  children: [
                    Text('¿NECESITAS AYUDA?', 
                         textAlign: TextAlign.center, 
                         style: GoogleFonts.orbitron(fontSize: 24, color: AppTheme.neonCyan, decoration: TextDecoration.none)),
                    const SizedBox(height: 30),
                    _whatsAppButton(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whatsAppButton() {
    return InkWell(
      onTap: _launchWhatsApp,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)]),
          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20)],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.white),
            SizedBox(width: 15),
            Text('CHATEAR AHORA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, decoration: TextDecoration.none)),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2000.ms);
  }

  Widget _contactInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.neonCyan.withOpacity(0.1)),
            child: Icon(icon, color: AppTheme.neonCyan, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.neonPurple, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              Text(value, style: const TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none), overflow: TextOverflow.ellipsis),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      color: Colors.black,
      child: const Center(child: Text('© 2026 Compusolución. Innovación desde Conkal, Yucatán.', style: TextStyle(decoration: TextDecoration.none))),
    );
  }
}
