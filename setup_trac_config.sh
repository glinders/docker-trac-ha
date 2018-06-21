setup_components() {
    trac-admin $1 config set components tracext.git.* enabled 
    trac-admin $1 config set components trac_gitolite.* enabled 
    trac-admin $1 config set components trac.web.auth.LoginModule disabled 
    trac-admin $1 config set components acct_mgr.web_ui.* enabled 
    trac-admin $1 config set components acct_mgr.admin.* enabled 
    trac-admin $1 config set components acct_mgr.register.* enabled 
    trac-admin $1 config set components acct_mgr.notification.* enabled 
    trac-admin $1 config set components acct_mgr.htfile.* disabled 
    trac-admin $1 config set components acct_mgr.db.sessionstore enabled 
    trac-admin $1 config set components acct_mgr.pwhash.htdigesthashmethod enabled 
    trac-admin $1 config set components acct_mgr.pwhash.htpasswdhashmethod disabled 
    trac-admin $1 config set components acct_mgr.svnserve.svnservepasswordstore disabled
}

setup_accountmanager() {
    trac-admin $1 config set account-manager hash_method HtDigestHashMethod 
    trac-admin $1 config set account-manager db_htdigest_realm TracDB 
    trac-admin $1 config set account-manager password_store SessionStore 
    trac-admin $1 config set account-manager reset_password false
}

setup_admin_user() {
    trac-admin $1 session add admin admin root@localhost
    trac-admin $1 permission add admin TRAC_ADMIN

    if [ ! -f /.trac_admin_password ]
    then
        TRAC_PASS=$(pwgen -1 10 -s)
        _S=$(printf '=%0.s' {1..50})
        set_trac_user_password.py $1 admin ${TRAC_PASS}
        echo $_S
        echo Trac admin login
            echo -e "\tUser: admin"
            echo -e "\tPassword: ${TRAC_PASS}"
        echo $_S
        echo ${TRAC_PASS} >/.trac_admin_password
    fi

}
