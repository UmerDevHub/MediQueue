'use client';

export type StatusType = 
  | 'accepted' 
  | 'en_route' 
  | 'arrived' 
  | 'completed' 
  | 'cancelled' 
  | 'booked' 
  | 'incoming' 
  | 'done';

interface StatusBadgeProps {
  status: StatusType;
}

export default function StatusBadge({ status }: StatusBadgeProps) {
  const getBadgeStyles = () => {
    switch (status) {
      case 'accepted':
      case 'arrived':
      case 'booked':
        return 'bg-blue-50 text-[#2563EB] border-[#2563EB]/20';
      case 'en_route':
        return 'bg-amber-50 text-[#D97706] border-[#D97706]/20';
      case 'completed':
      case 'done':
        return 'bg-green-50 text-[#16A34A] border-[#16A34A]/20';
      case 'cancelled':
        return 'bg-slate-50 text-[#64748B] border-[#64748B]/20';
      case 'incoming':
        return 'bg-red-50 text-[#DC2626] border-[#DC2626]/20';
      default:
        return 'bg-slate-50 text-slate-600 border-slate-200';
    }
  };

  const formatStatus = (s: string) => {
    return s.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
  };

  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${getBadgeStyles()}`}>
      {formatStatus(status)}
    </span>
  );
}
