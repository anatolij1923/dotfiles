import subprocess
import time
import os

path = os.path.expanduser("~/dotfiles/shell/app.ts")


def run_shell():
    while True:
        print("Starting shell")
        proc = subprocess.Popen(
            ["ags", "run", path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )

        stdout, stderr = proc.communicate()
        exit_code = proc.returncode

        err_output = (stderr or b"").decode("utf-8")

        print(f"AGS crashed with exit code: {exit_code}")
        # if "Error 71" in err_output or "protocol error" in err_output.lower():
        #     print("Restart")
        # else:
        #     print("Обычное завершение AGS или другая ошибка, перезапуск через 2 секунды...")

        time.sleep(0.5)


if __name__ == "__main__":
    run_shell()
