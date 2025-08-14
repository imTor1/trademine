import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trademine/bloc/notification/notificationCubit.dart';
import 'package:trademine/bloc/notification/notificationState.dart';
import 'package:trademine/page/news_detail/news_detail.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchLatestNotifications();
  }

  String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat("dd MMM yyyy, HH:mm").format(date);
    } catch (_) {
      return isoDate;
    }
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationCubit>().fetchLatestNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              centerTitle: false,
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              sliver: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is NotificationError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            state.message,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is NotificationLoaded) {
                    final items = state.notifications;
                    if (items.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: Text('No new notifications')),
                        ),
                      );
                    }

                    return SliverList.separated(
                      itemCount: items.length + 2,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 8),
                            child: Text(
                              'New',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          );
                        }
                        if (index == items.length + 1) {
                          return const SizedBox(height: 20);
                        }
                        final notif = items[index - 1];
                        return NotificationItem(
                          title: notif['NewsTitle'] ?? '',
                          message: notif['Message'] ?? '',
                          dateText: formatDate(notif['Date'] ?? ''),
                          onTap: () {
                            final newsId = notif['NewsID'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewsDetail(NewsID: newsId),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String dateText;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
    required this.dateText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: onSurface.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Texts(
                    title: title,
                    message: message,
                    dateText: dateText,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: onSurface.withOpacity(0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  final String title;
  final String message;
  final String dateText;

  const _Texts({
    required this.title,
    required this.message,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.isEmpty ? '-' : title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          message.isEmpty ? '-' : message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.25,
            color: onSurface.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dateText,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: onSurface.withOpacity(0.55)),
        ),
      ],
    );
  }
}
