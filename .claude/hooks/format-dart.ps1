# Windows only (PowerShell 5.1). Not portable to bash, macOS or Linux.
# PostToolUse hook: formats the .dart file that Claude just edited.
# Exit 0: nothing to do, or formatted. Exit 2: any failure (stderr reaches Claude).

$ErrorActionPreference = 'Stop'

try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $path = $payload.tool_input.file_path

    if (-not $path -or -not $path.EndsWith('.dart', [StringComparison]::OrdinalIgnoreCase)) {
        exit 0
    }

    # Only format files inside the project directory.
    $root = [IO.Path]::GetFullPath($env:CLAUDE_PROJECT_DIR).TrimEnd('\') + '\'
    $full = [IO.Path]::GetFullPath($path)
    if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
        exit 0
    }

    # dart format reports syntax errors on stdout; capture it to relay on failure.
    $output = & dart format -- "$full" | Out-String
    if ($LASTEXITCODE -ne 0) {
        [Console]::Error.WriteLine("dart format failed for $full (exit code $LASTEXITCODE)`n$output")
        exit 2
    }
    exit 0
}
catch {
    [Console]::Error.WriteLine("format-dart hook error: $($_.Exception.Message)")
    exit 2
}
