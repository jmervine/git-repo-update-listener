timeout          30
preload_app      true
worker_processes 1
stderr_path      File.join( File.dirname(__FILE__), "..", "log", "unicorn_stderr.log" )
stdout_path      File.join( File.dirname(__FILE__), "..", "log", "unicorn_stdout.log" )
pid              File.join( File.dirname(__FILE__), "..", "log", "listener.pid" )
listen           "#{ %x{ hostname }.strip }:54321"
