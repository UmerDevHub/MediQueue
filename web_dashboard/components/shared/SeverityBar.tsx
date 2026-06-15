'use client';

export type SeverityLevel = 1 | 2 | 3 | 4 | 5;

interface SeverityBarProps {
  level: SeverityLevel;
}

export default function SeverityBar({ level }: SeverityBarProps) {
  const getSeverityDetails = () => {
    switch (level) {
      case 1:
        return { label: 'RED - LEVEL 1', classes: 'bg-red-50 text-[#DC2626] border-[#DC2626]/20' };
      case 2:
        return { label: 'YELLOW - LEVEL 2', classes: 'bg-amber-50 text-[#D97706] border-[#D97706]/20' };
      case 3:
        return { label: 'GREEN - LEVEL 3', classes: 'bg-green-50 text-[#16A34A] border-[#16A34A]/20' };
      case 4:
        return { label: 'BLUE - LEVEL 4', classes: 'bg-blue-50 text-[#2563EB] border-[#2563EB]/20' };
      case 5:
        return { label: 'WHITE - LEVEL 5', classes: 'bg-slate-50 text-[#64748B] border-[#64748B]/20' };
      default:
        return { label: `LEVEL ${level}`, classes: 'bg-slate-50 text-[#64748B] border-[#64748B]/20' };
    }
  };

  const details = getSeverityDetails();

  return (
    <span className={`px-2 py-1 rounded text-xs font-semibold border ${details.classes}`}>
      {details.label}
    </span>
  );
}
