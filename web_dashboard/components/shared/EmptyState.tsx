'use client';

interface EmptyStateProps {
  title: string;
  message: string;
  icon?: string;
}

export default function EmptyState({ title, message, icon = 'inbox' }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center p-12 text-center bg-surface border border-border rounded-xl shadow-sm">
      <div className="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
        <span className="material-symbols-outlined text-4xl text-textmuted opacity-50">
          {icon}
        </span>
      </div>
      <h3 className="text-lg font-semibold text-textprimary mb-2">{title}</h3>
      <p className="text-sm text-textmuted max-w-sm">{message}</p>
    </div>
  );
}
