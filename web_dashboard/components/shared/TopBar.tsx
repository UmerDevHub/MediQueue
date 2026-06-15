'use client';

interface TopBarProps {
  title: string;
}

export default function TopBar({ title }: TopBarProps) {
  return (
    <header className="fixed top-0 right-0 w-[calc(100%-240px)] h-16 bg-surface border-b border-border shadow-sm flex items-center justify-between px-6 z-40">
      <div className="flex items-center gap-8 flex-1">
        <div className="text-xl font-semibold text-textprimary">{title}</div>
        <div className="relative w-full max-w-md hidden md:block">
          <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-textmuted">search</span>
          <input 
            className="w-full bg-background border border-border rounded-lg py-2 pl-10 pr-4 text-sm text-textprimary focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" 
            placeholder="Search users, doctors, or records..." 
            type="text"
          />
        </div>
      </div>
      <div className="flex items-center gap-4">
        <button className="p-2 rounded-full hover:bg-background transition-colors active:scale-[0.97]">
          <span className="material-symbols-outlined text-textmuted">notifications</span>
        </button>
        <button className="p-2 rounded-full hover:bg-background transition-colors active:scale-[0.97]">
          <span className="material-symbols-outlined text-textmuted">help</span>
        </button>
        <div className="h-8 w-[1px] bg-border mx-2"></div>
        <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center border border-primary/20 cursor-pointer hover:bg-primary/20 transition-colors">
            <span className="material-symbols-outlined text-primary">person</span>
        </div>
      </div>
    </header>
  );
}
