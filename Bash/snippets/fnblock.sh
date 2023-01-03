#! /bin/bash
# solid cards
# solid needs lowercase folder names for routes.
mkdir "${1,}"
cd "${1,}"
touch "${1,}.module.scss"

cat <<EOF> "index.tsx"
import { Title } from "solid-start";
import styles from "./${1,}.module.scss";

export default function ${1^}() {
  return (
    <>
      <Title>${1^}</Title>
      <h1>${1^} Page</h1>
    </>
  );
}
EOF