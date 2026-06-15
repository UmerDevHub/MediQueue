'use client';

export default function LoadingSkeleton() {
  return (
    <div className="w-full space-y-4 p-4 animate-pulse">
      <div className="h-8 bg-slate-200 rounded w-1/4"></div>
      <div className="space-y-3">
        <div className="h-20 bg-slate-200 rounded"></div>
        <div className="h-20 bg-slate-200 rounded"></div>
        <div className="h-20 bg-slate-200 rounded"></div>
      </div>
    </div>
  );
}
