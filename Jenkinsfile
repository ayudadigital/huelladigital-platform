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
                sh """
                cp vault/.env.local .env
                devcontrol run-bash-linter
                """
            }
        }
        /* Disabled because diff method of check does not work
        stage ('OWASP tests') {
            steps {
                sh "devcontrol owasp-tests"
            }
            post {
                always {
                    archiveArtifacts artifacts: 'activescan-report.html', fingerprint: true, allowEmptyArchive: true
                    archiveArtifacts artifacts: 'baselinescan-report.txt', fingerprint: true, allowEmptyArchive: true
                    publishHTML (target : [allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: '.',
                        reportFiles: 'activescan-report.html',
                        reportName: 'OWASP ZAP ActiveScan',
                        reportTitles: 'OWASP ZAP ActiveScan'])
                }
            }
        }
        */
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
            when { branch 'release/new' }
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
