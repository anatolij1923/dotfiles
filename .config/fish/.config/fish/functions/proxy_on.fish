function proxy_on
    set -gx all_proxy socks5h://127.0.0.1:7890
    
    set -gx http_proxy http://127.0.0.1:7890
    set -gx https_proxy http://127.0.0.1:7890
    
    set -gx no_proxy "localhost,127.0.0.1,::1"
    
end
