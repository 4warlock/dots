#!/usr/bin/env python3
"""
Terminal-based Pomodoro/Time Logger
Usage: python timelogger.py
"""

import os
import sys
import json
import time
from datetime import datetime, timedelta
from pathlib import Path
from threading import Thread, Event
from collections import defaultdict
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt, IntPrompt
from rich.live import Live
from rich.table import Table
from rich.text import Text
from pynput import keyboard

console = Console()

# Config
LOG_FILE = Path.home() / ".timelogger" / "sessions.json"
LOG_FILE.parent.mkdir(exist_ok=True)

class TimeLogger:
    def __init__(self):
        self.running = False
        self.paused = False
        self.start_time = None
        self.elapsed = 0
        self.task = ""
        self.mode = ""
        self.duration = 0
        self.visible = True
        self.stop_event = Event()
        
    def log_session(self, elapsed_seconds):
        """Save completed session to log file"""
        session = {
            "date": datetime.now().isoformat(),
            "task": self.task,
            "mode": self.mode,
            "duration_seconds": elapsed_seconds,
            "duration_formatted": str(timedelta(seconds=int(elapsed_seconds)))
        }
        
        # Load existing sessions
        sessions = []
        if LOG_FILE.exists():
            with open(LOG_FILE, 'r') as f:
                sessions = json.load(f)
        
        sessions.append(session)
        
        # Save updated sessions
        with open(LOG_FILE, 'w') as f:
            json.dump(sessions, f, indent=2)
        
        console.print(f"\n[green]✓ Session logged:[/green] {self.task} - {timedelta(seconds=int(elapsed_seconds))}")
        console.print(f"[dim]Saved to {LOG_FILE}[/dim]")

    def format_time(self, seconds):
        """Format seconds into HH:MM:SS"""
        return str(timedelta(seconds=int(seconds)))
    
    def create_display(self):
        """Create the timer display panel"""
        elapsed_time = self.format_time(self.elapsed)
        
        # Create display based on mode
        if self.mode == "pomodoro":
            remaining = max(0, self.duration * 60 - self.elapsed)
            remaining_time = self.format_time(remaining)
            progress = (self.elapsed / (self.duration * 60)) * 100 if self.duration > 0 else 0
            
            status = "⏸ PAUSED" if self.paused else "⏱ RUNNING"
            color = "yellow" if self.paused else "green"
            
            content = f"""[bold cyan]{self.task}[/bold cyan]
            
[{color}]{status}[/{color}]
Mode: Pomodoro ({self.duration} min)

⏱  Elapsed:   {elapsed_time}
⏳ Remaining: {remaining_time}
📊 Progress:  {progress:.0f}%

[dim]Press Ctrl+P to hide/show | Ctrl+C to stop[/dim]"""
        else:
            status = "⏸ PAUSED" if self.paused else "⏱ RUNNING"
            color = "yellow" if self.paused else "green"
            
            content = f"""[bold cyan]{self.task}[/bold cyan]
            
[{color}]{status}[/{color}]
Mode: Continuous Timer

⏱  Time: {elapsed_time}

[dim]Press Ctrl+P to hide/show | Ctrl+C to stop[/dim]"""
        
        return Panel(content, border_style="bold blue", padding=(1, 2))
    
    def on_press(self, key):
        """Handle keyboard shortcuts"""
        try:
            if key == keyboard.Key.ctrl_l or key == keyboard.Key.ctrl_r:
                return
            # Ctrl+P to toggle visibility
            if hasattr(key, 'char') and key.char == 'p':
                if keyboard.Controller().pressed(keyboard.Key.ctrl):
                    self.visible = not self.visible
        except:
            pass
    
    def run_timer(self):
        """Main timer loop"""
        self.start_time = time.time()
        self.running = True
        
        # Set up keyboard listener
        listener = keyboard.Listener(on_press=self.on_press)
        listener.start()
        
        try:
            with Live(self.create_display(), console=console, refresh_per_second=1) as live:
                while self.running:
                    if not self.paused:
                        self.elapsed = time.time() - self.start_time
                        
                        # Check if pomodoro time is up
                        if self.mode == "pomodoro" and self.elapsed >= self.duration * 60:
                            self.running = False
                            console.print("\n[bold green]🎉 Pomodoro Complete![/bold green]")
                            break
                    
                    if self.visible:
                        live.update(self.create_display())
                    else:
                        live.update(Panel("[dim]Timer hidden - Press Ctrl+P to show[/dim]", border_style="dim"))
                    
                    time.sleep(0.1)
        except KeyboardInterrupt:
            console.print("\n[yellow]Timer stopped by user[/yellow]")
        finally:
            listener.stop()
            self.log_session(self.elapsed)

def load_sessions():
    """Load all logged sessions"""
    if not LOG_FILE.exists():
        return []
    
    with open(LOG_FILE, 'r') as f:
        return json.load(f)

def view_stats():
    """Display statistics for logged sessions"""
    sessions = load_sessions()
    
    if not sessions:
        console.print("\n[yellow]No sessions logged yet. Start a timer to begin tracking![/yellow]")
        return
    
    # Group by task
    task_stats = defaultdict(lambda: {"count": 0, "total_seconds": 0, "sessions": []})
    
    for session in sessions:
        task = session["task"]
        task_stats[task]["count"] += 1
        task_stats[task]["total_seconds"] += session["duration_seconds"]
        task_stats[task]["sessions"].append(session)
    
    # Display overall stats
    console.print("\n[bold cyan]📊 All Tasks Summary[/bold cyan]\n")
    
    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Task", style="cyan")
    table.add_column("Sessions", justify="right")
    table.add_column("Total Time", justify="right")
    table.add_column("Avg Session", justify="right")
    
    # Sort by total time
    sorted_tasks = sorted(task_stats.items(), key=lambda x: x[1]["total_seconds"], reverse=True)
    
    for task, stats in sorted_tasks:
        total_time = str(timedelta(seconds=int(stats["total_seconds"])))
        avg_time = str(timedelta(seconds=int(stats["total_seconds"] / stats["count"])))
        table.add_row(task, str(stats["count"]), total_time, avg_time)
    
    console.print(table)
    
    # Grand total
    total_seconds = sum(s["duration_seconds"] for s in sessions)
    total_sessions = len(sessions)
    console.print(f"\n[bold]Grand Total:[/bold] {total_sessions} sessions • {timedelta(seconds=int(total_seconds))}")

def view_task_details(task_filter=None):
    """Display detailed view for a specific task"""
    sessions = load_sessions()
    
    if not sessions:
        console.print("\n[yellow]No sessions logged yet.[/yellow]")
        return
    
    # Get unique tasks
    tasks = sorted(set(s["task"] for s in sessions))
    
    if not task_filter:
        console.print("\n[bold]Available tasks:[/bold]")
        for i, task in enumerate(tasks, 1):
            console.print(f"{i}. {task}")
        
        choice = Prompt.ask("\nEnter task name or number", default="1")
        
        # Handle numeric choice
        if choice.isdigit() and 1 <= int(choice) <= len(tasks):
            task_filter = tasks[int(choice) - 1]
        else:
            task_filter = choice
    
    # Filter sessions for this task
    filtered = [s for s in sessions if s["task"] == task_filter]
    
    if not filtered:
        console.print(f"\n[yellow]No sessions found for task: {task_filter}[/yellow]")
        return
    
    # Display task details
    console.clear()
    console.print(Panel.fit(
        f"[bold cyan]📋 Task Details: {task_filter}[/bold cyan]",
        border_style="cyan"
    ))
    
    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Date", style="dim")
    table.add_column("Time", style="dim")
    table.add_column("Mode", style="cyan")
    table.add_column("Duration", justify="right", style="green")
    
    total_seconds = 0
    for session in reversed(filtered):  # Most recent first
        date_obj = datetime.fromisoformat(session["date"])
        date_str = date_obj.strftime("%Y-%m-%d")
        time_str = date_obj.strftime("%H:%M")
        
        table.add_row(
            date_str,
            time_str,
            session["mode"].capitalize(),
            session["duration_formatted"]
        )
        total_seconds += session["duration_seconds"]
    
    console.print(f"\n{table}")
    
    # Summary
    avg_seconds = total_seconds / len(filtered)
    console.print(f"\n[bold cyan]Summary for {task_filter}:[/bold cyan]")
    console.print(f"  Total sessions: {len(filtered)}")
    console.print(f"  Total time:     {timedelta(seconds=int(total_seconds))}")
    console.print(f"  Average:        {timedelta(seconds=int(avg_seconds))}")

def main_menu():
    """Display main menu and handle user choice"""
    console.clear()
    console.print(Panel.fit(
        "[bold cyan]⏱  Time Logger & Pomodoro Timer[/bold cyan]\n[dim]Track your work sessions[/dim]",
        border_style="cyan"
    ))
    
    console.print("\n[bold]Main Menu:[/bold]")
    console.print("1. Start New Timer")
    console.print("2. View All Tasks Summary")
    console.print("3. View Specific Task Details")
    console.print("4. Exit")
    
    choice = Prompt.ask("\nChoose", choices=["1", "2", "3", "4"], default="1")
    
    if choice == "1":
        start_timer()
    elif choice == "2":
        view_stats()
        input("\nPress Enter to return to menu...")
        main_menu()
    elif choice == "3":
        view_task_details()
        input("\nPress Enter to return to menu...")
        main_menu()
    elif choice == "4":
        console.print("\n[cyan]Happy tracking! 👋[/cyan]")
        sys.exit(0)

def start_timer():
    """Start a new timer session"""
    console.clear()
    console.print(Panel.fit(
        "[bold cyan]⏱  Start New Timer[/bold cyan]",
        border_style="cyan"
    ))
    
    # Mode selection
    console.print("\n[bold]Select Mode:[/bold]")
    console.print("1. Continuous Timer")
    console.print("2. Pomodoro Timer")
    
    mode_choice = Prompt.ask("Choose", choices=["1", "2"], default="1")
    
    logger = TimeLogger()
    
    if mode_choice == "2":
        logger.mode = "pomodoro"
        logger.duration = IntPrompt.ask("\n[bold]Pomodoro duration (minutes)[/bold]", default=25)
    else:
        logger.mode = "continuous"
    
    # Task selection
    logger.task = Prompt.ask("\n[bold]What task are you working on?[/bold]", default="#work").upper()
    
    # Confirmation
    console.print(f"\n[green]✓[/green] Starting {logger.mode} timer for: [bold]{logger.task}[/bold]")
    time.sleep(1)
    
    console.clear()
    logger.run_timer()
    
    console.print("\n[dim]Session complete.[/dim]")
    time.sleep(2)
    main_menu()

if __name__ == "__main__":
    main_menu()
