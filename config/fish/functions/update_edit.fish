function update_edit
    set tmpdir (mktemp -d)
    cd $tmpdir
    
    echo "🔎 Checking latest Microsoft/Edit release..."
    set url (curl -s https://api.github.com/repos/microsoft/edit/releases/latest \
                    | grep browser_download_url \
                    | grep x86_64-linux-gnu.tar.zst \
                    | cut -d '"' -f 4)
    
    echo "⬇️ Downloading $url"
    wget -q $url -O edit.tar.zst
    tar -xf edit.tar.zst
    
    echo "📦 Installing to /usr/local/bin"
    sudo mv -f edit /usr/local/bin/
    
    echo "✅ Installed version:" (edit --version)
    
    cd -
    rm -rf $tmpdir
end
