import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'events/event_details_screen.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  // Dummy event data - replace with actual data from backend
  final List<Map<String, dynamic>> _allEvents = [
    {
      'title': 'Annual Tech Symposium 2024',
      'date': 'March 15, 2024',
      'time': '10:00 AM',
      'location': 'Main Auditorium, Engineering Block',
      'description': 'Join us for a day of innovation and technology discussions with industry experts and fellow students.',
      'category': 'Academic',
      'image': 'https://picsum.photos/800/400',
    },
    {
      'title': 'Sports Day 2024',
      'date': 'March 20, 2024',
      'time': '9:00 AM',
      'location': 'University Sports Complex',
      'description': 'Annual sports day with various competitions and activities.',
      'category': 'Sports',
      'image': 'https://picsum.photos/800/401',
    },
    {
      'title': 'Cultural Festival',
      'date': 'March 25, 2024',
      'time': '6:00 PM',
      'location': 'Open Air Theater',
      'description': 'Celebrate diversity with music, dance, and cultural performances.',
      'category': 'Cultural',
      'image': 'https://picsum.photos/800/402',
    },
    {
      'title': 'Web Development Workshop',
      'date': 'April 1, 2024',
      'time': '2:00 PM',
      'location': 'Computer Lab 101',
      'description': 'Learn modern web development technologies and best practices.',
      'category': 'Workshops',
      'image': 'https://picsum.photos/800/403',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    return _allEvents.where((event) {
      final matchesSearch = event['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || event['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Bridge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {

            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildEventsTab(),
          _buildMyEventsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'My Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Categories
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryChip(
                        label: 'All',
                        isSelected: _selectedCategory == 'All',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = 'All';
                            });
                          }
                        },
                      ),
                      _CategoryChip(
                        label: 'Academic',
                        isSelected: _selectedCategory == 'Academic',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = 'Academic';
                            });
                          }
                        },
                      ),
                      _CategoryChip(
                        label: 'Sports',
                        isSelected: _selectedCategory == 'Sports',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = 'Sports';
                            });
                          }
                        },
                      ),
                      _CategoryChip(
                        label: 'Cultural',
                        isSelected: _selectedCategory == 'Cultural',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = 'Cultural';
                            });
                          }
                        },
                      ),
                      _CategoryChip(
                        label: 'Workshops',
                        isSelected: _selectedCategory == 'Workshops',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = 'Workshops';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Event List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = _filteredEvents[index];
                return _EventCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventDetailsScreen(),
                      ),
                    );
                  },
                );
              },
              childCount: _filteredEvents.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyEventsTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Events',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Tabs for different event states
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: const [
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Past'),
                          Tab(text: 'Saved'),
                        ],
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppTheme.primaryColor,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 300,
                        child: TabBarView(
                          children: [
                            _buildEventList('upcoming'),
                            _buildEventList('past'),
                            _buildEventList('saved'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(String type) {
    // TODO: Replace with actual data from backend
    final List<Map<String, dynamic>> dummyEvents = [
      {
        'title': 'Tech Workshop',
        'date': 'March 20, 2024',
        'time': '2:00 PM',
        'location': 'Room 101',
        'image': 'https://picsum.photos/800/400',
      },
      {
        'title': 'Coding Competition',
        'date': 'March 25, 2024',
        'time': '10:00 AM',
        'location': 'Main Hall',
        'image': 'https://picsum.photos/800/401',
      },
    ];

    return ListView.builder(
      itemCount: dummyEvents.length,
      itemBuilder: (context, index) {
        final event = dummyEvents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                event['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(event['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${event['date']} • ${event['time']}'),
                Text(event['location']),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showEventOptions(context, event);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventDetailsScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEventOptions(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Event'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to edit event screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Event'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement share functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Cancel Registration', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showCancelConfirmation(context, event);
            },
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Registration'),
        content: Text('Are you sure you want to cancel your registration for ${event['title']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement cancellation logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration cancelled successfully')),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Events', '12'),
                    _buildStatItem('Following', '45'),
                    _buildStatItem('Followers', '89'),
                  ],
                ),
              ],
            ),
          ),
          // Profile Options
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildProfileOption(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  // TODO: Navigate to edit profile screen
                },
              ),
              _buildProfileOption(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to notifications screen
                },
              ),
              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  // TODO: Navigate to settings screen
                },
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to help screen
                },
              ),
              _buildProfileOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _showLogoutConfirmation(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(event['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Event Details
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${event['date']} • ${event['time']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        event['location'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Event Description
                  Text(
                    event['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Handle registration
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Register'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          // TODO: Handle share
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 