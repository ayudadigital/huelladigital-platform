#!groovy

@Library('github.com/ayudadigital/jenkins-pipeline-library@v5.0.0') _

// Initialize global config
cfg = jplConfig('huelladigital-platform', 'platform', '', [email: env.CI_NOTIFY_EMAIL_TARGETS])

pipeline {
    agent { label 'docker' }

    stages {
        stage ('Initialize') {
            steps  {
                jplStart(cfg)
            }
        }
        stage ('Bash linter') {
            steps {
                script {
                    sh """
                    cp .env.dist .env
                    devcontrol run-bash-linter
                    """
                }
            }
        }

        stage("Remote deploy") {
            when { branch 'develop' }
            environment {
                KEY = credentials('huelladigital-platform-vault-key')
            }
            agent {
                docker {
                    image 'ayudadigital/gp-jenkins'
                    label 'docker'
                    args '--entrypoint=""'
                }
            }
            steps {
                sshagent (credentials: ['jpl-ssh-credentials']) {
                    sh """
                    set +x
                    export HOME=/tmp
                    echo $KEY | tr ',' '\n' | gpg --import
                    git-secret reveal
                    bin/deploy.sh dev
                    """
                }
            }
            post {
                cleanup {
                    fileOperations([fileDeleteOperation(includes: 'vault/.env.dev')])
                }
            }
        }
        stage('Make release') {
            when { expression { cfg.BRANCH_NAME.startsWith('release/new') } }
            steps {
                jplMakeRelease(cfg, true)
                deleteDir()
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 10, unit: 'MINUTES')
    }
}
