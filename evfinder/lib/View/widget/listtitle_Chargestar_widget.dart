import 'package:flutter/material.dart';

class ListtileChargestarWidget extends StatefulWidget {
  const ListtileChargestarWidget({
    super.key,
    required this.stationName,
    required this.stationAddress,
    required this.operatingHours,
    required this.chargerStat,
    required this.distance,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  final String stationName;
  final String stationAddress;
  final String operatingHours;
  final int chargerStat; // 0: 불가능, 1: 가능
  final String distance;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  @override
  State<ListtileChargestarWidget> createState() => _ListtileChargestarWidgetState();
}

class _ListtileChargestarWidgetState extends State<ListtileChargestarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  late bool isFavorite; // 내부 상태로 관리

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite; // 초기 상태 설정

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFavoritePressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      isFavorite = !isFavorite; // 내부 상태 토글
    });

    widget.onFavoriteToggle?.call(); // 콜백 호출
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 충전소 아이콘
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1FAE5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.electric_car,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // 충전소 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 충전소 이름과 상태
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.stationName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(widget.chargerStat).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              getStatusLabel(widget.chargerStat),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: getStatusColor(widget.chargerStat),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // 주소
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.stationAddress,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.distance,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // 운영시간
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.operatingHours,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 버튼
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: GestureDetector(
                        onTap: _onFavoritePressed,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


String getStatusLabel(int stat) {
  switch (stat) {
    case 0: return '알수없음';
    case 1: return '통신이상';
    case 2: return '이용가능';
    case 3: return '충전중';
    case 4: return '운영중지';
    case 5: return '점검중';
    default: return '알수없음';
  }
}

Color getStatusColor(int stat) {
  switch (stat) {
    case 2:
      return const Color(0xFF059669); // 초록 (사용 가능)
    case 3:
      return const Color(0xFF2563EB); // 파랑 (충전 중)
    case 4:
    case 5:
      return const Color(0xFFDC2626); // 빨강 (중지, 점검)
    case 1:
      return const Color(0xFFF97316); // 주황 (통신이상)
    default:
      return const Color(0xFF9CA3AF); // 회색 (기타)
  }
}