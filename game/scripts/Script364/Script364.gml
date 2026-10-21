function evaluate_command(prog, arg) {
  prog = string_replace_all(prog, @'\', @'\\');
  prog = string_replace_all(prog, @'"', @'\"');
  if (os_type == os_windows && 
    (string_lower(filename_name(prog)) == "cmd" ||
    string_lower(filename_name(prog)) == "cmd.exe")) 
  { prog = "cmd.exe"; arg = "/c " + arg; } 
  prog = @'"' + prog + @'"'; var pre = "";
  if (os_type == os_windows) pre = "cmd /c";
  var pid = ProcessExecute(pre + " " +prog + " " + arg);
  var out = ExecutedProcessReadFromStandardOutput(pid);
  
  FreeExecutedProcessStandardInput(pid);
  FreeExecutedProcessStandardOutput(pid);
  return out;
}