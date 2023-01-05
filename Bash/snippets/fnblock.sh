#! /bin/bash
# fnblock "FolderName"
properName="${1^}"
fileName="${properName}.tsx"

mkdir $properName
cd "$properName"
touch "${properName}.module.scss"

cat <<EOF> "${properName}.tsx"
import styles from "./${properName}.module.scss";

export function ${properName}() {
  return (
    <>
      <h1>${properName} Page</h1>
    </>
  );
}
EOF

cat <<EOF> "index.tsx"
export * from './${properName}';
EOF